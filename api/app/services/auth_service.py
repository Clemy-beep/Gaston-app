from fastapi import HTTPException, Request, status, Depends
from sqlalchemy import or_
from sqlalchemy.orm import Session
import bcrypt
from validators.users import UserCreate
from services.user_service import UserService
from entities.users import UserEntity
from services.jwt_service import JWTService
from validators.auth_validator import RegisterValidator
from validators.error_validator import ErrorValidator

from ._singleton import Singleton
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class AuthService(metaclass=Singleton):
    def __init__(self, userSvc: UserService = UserService()):
        self._userSvc = userSvc
        
    def __password_hash(self, password: str):
        return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt(12))

    def register(self, session: Session, UserCreate: UserCreate):
        user = (
            session.query(UserEntity)
            .filter(
                or_(
                    UserEntity.email == UserCreate.email,
                    UserEntity.username == UserCreate.username,
                )
            )
            .first()
        )
        if user:
            return HTTPException(status_code=400, detail="already exist")
        else:
            hashed_password = self.__password_hash(UserCreate.password)
            UserCreate.password = hashed_password
            new_user = self._userSvc.create_user(session, UserCreate)
            return {"ok": "User created"}

    def login(self, session: Session, identifier: str, password: str):
        user = self._userSvc.get_user(session=session, identifier=identifier)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        
        if user and user.roles and self._userSvc.has_role_banned(user):
            raise HTTPException(status_code=403, detail="User is banned")

        if bcrypt.checkpw(password.encode("utf-8"), user.password):
            token_data = {"sub": user.username, "role": user.roles}
            if user.token is None or JWTService.is_token_expired(user.token):
                return {
                    "ok": "Login successful",
                    "token": JWTService.encode(data=token_data),
                }
            else:
                token = JWTService.encode(data=token_data)
                user.token = token
                session.commit()
                return {"ok": "Login successful", "token": user.token}
        else:
            raise HTTPException(status_code=400, detail="Incorrect password")

    def add_user_role(self, session: Session, role: str, user_id: int):
        """add a role to a user only by admin (protected call in router)"""
        user = self._userSvc.get_user_by_id(session, user_id)
        if user and user.roles and role in user.roles:
            user.roles.append(role)
            session.commit()
            return {"ok": "Role added"}
        else:
            raise HTTPException(status_code=404, detail="User not found")
        
    def remove_user_role(self, session: Session, role: str, user_id: int):
        """remove a role to a user only by admin (protected call in router)"""
        user = self._userSvc.get_user_by_id(session, user_id)
        user.roles.remove(role)
        session.commit()
        return {"ok": "Role removed"}

    # def need_role_user(self, user: dict = Depends(JWTService.get_token_user_data)) -> bool:
    #     user_role = user.get("role", "")
    #     if user_role.lower() in ["user", "admin", "modo"]:
    #         return True
    #     else:
    #         raise HTTPException(
    #             status_code=status.HTTP_403_FORBIDDEN,
    #             detail="Not enough permissions"
    #         )
