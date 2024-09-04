from fastapi import HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.orm.attributes import flag_modified
from entities.users import UserEntity
from sqlalchemy.exc import IntegrityError
from ._singleton import Singleton
from validators.users import UserCreate, UserUpdate
import logging
import re

# Configuration du logger (à faire une seule fois, généralement au démarrage de l'application)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class UserService(metaclass=Singleton):
    _email_regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    def get_all_users(self, session: Session):
        db_users = session.query(UserEntity).all()
        return db_users

    def get_user_by_email_or_username(self, session: Session, email: str = None, username: str = None):
        query = session.query(UserEntity)
        if email:
            query = query.filter(UserEntity.email == email)
        elif username:
            query = query.filter(UserEntity.username == username)
        return query.first()
    
    def get_user_by_username(self, session: Session, username: str = None):
        query = session.query(UserEntity)
        query = query.filter(UserEntity.username == username)
        return query.first()

    def get_user(self, session: Session, identifier: str):
        if re.match(self._email_regex, identifier):  
            return session.query(UserEntity).filter(UserEntity.email == identifier).first()
        else:
            return session.query(UserEntity).filter(UserEntity.username == identifier).first()
        
    def get_user_by_id(self, session: Session, user_id: int):
        return session.query(UserEntity).filter(UserEntity.id == user_id).first()
    
    def has_role_user(self, user: UserEntity):
        if user and user.roles and "user" in user.roles:
            return True
        else:
            return False

    def has_role_banned(self, user: UserEntity):
        if user and user.roles and "banned" in user.roles:
            return True
        else:
            return False
    
    def has_role_admin(self, user: UserEntity):
        if user and user.roles and "admin" in user.roles:
            return True
        else:
            return False
        
    def has_role_modo(self, user: UserEntity):
        if user and user.roles and "modo" in user.roles:
            return True
        else:
            return False
        
    def has_role_admin_or_modo(self, user: UserEntity):
        if user and user.roles and ("admin" in user.roles or "modo" in user.roles):
            return True
        else:
            return False
    
    def create_user(self, session: Session, user: UserCreate):
        db_user = UserEntity(
            email=user.email,
            password=user.password,
            username=user.username,  
            firstname=user.firstname,  
            lastname=user.lastname,  
            biography=user.biography,  
        )

        session.add(db_user)
        session.commit()
        session.refresh(db_user)
        return db_user

    def update_user(self, session: Session, user_id: int, user: UserUpdate):
        db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
        if db_user:
            update_data = user.dict(exclude_unset=True)
            for key, value in update_data.items():
                setattr(db_user, key, value)
            session.commit()
            session.refresh(db_user)
            return db_user
        return None
    
    def delete_user(self, session: Session, user_id: int):
        db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
        if db_user:
            try:
                session.delete(db_user)
                session.commit()
                return db_user
            except IntegrityError:
                session.rollback()  # Important pour annuler la transaction en cours et éviter des états incohérents
                raise HTTPException(status_code=400, detail="Cannot delete user due to foreign key constraint.")
        return None
    
    def ban_user(self, session: Session, user_id: int):
        db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
        if db_user:
            if "banned" in db_user.roles:
                raise HTTPException(status_code=409, detail="User already banned")
            else:
                db_user.roles += ["banned"]
                flag_modified(db_user, "roles") # important for flagging the roles need to be updated
                session.commit()
                session.refresh(db_user)
                return True
            
    def unban_user(self, session: Session, user_id: int):
        db_user = session.query(UserEntity).filter(UserEntity.id == user_id).first()
        if db_user:
            if "banned" not in db_user.roles:
                raise HTTPException(status_code=409, detail="User already unbanned")
            else:
                db_user.roles.remove("banned")
                flag_modified(db_user, "roles") # important for flagging the roles need to be updated
                session.commit()
                session.refresh(db_user)
                return True
