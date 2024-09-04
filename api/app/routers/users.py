from typing import Annotated, Dict
from dependencies.auth import current_user, user_is_admin_or_modo, user_is_user
from services.auth_service import AuthService
from entities.users import UserEntity
from fastapi import APIRouter, Depends, File, HTTPException, Request, UploadFile, status
from services.user_service import UserService
from services.security_service import SecurityService
from services.jwt_service import JWTService
from validators.users import UserUpdate, UserInDB
from sqlalchemy.orm import sessionmaker
from dependencies.database import engine
from dependencies.database import engine, get_session
import logging
from sqlalchemy.orm import Session
from services.upload_image_service import UploadImageService

uploadSVC = UploadImageService()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter()

userService = UserService()
securityService = SecurityService()
auth_service = AuthService()

@router.get("/all", tags=["users"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def get_all_users(session: Session = Depends(get_session)):
    db_users = userService.get_all_users(session=session)
    session.close()
    if db_users is None or len(db_users) == 0:
        raise HTTPException(status_code=404, detail="No users found")
    return db_users

@router.get("/me", tags=["users"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def get_user(request: Request, is_user: bool=Depends(user_is_user),  user: UserEntity = Depends(current_user)):
    return user

@router.get("/{user_id}", tags=["users"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def read_user(user_id: int, session: Session = Depends(get_session)):
    db_user = userService.get_user_by_id(session=session, user_id=user_id)
    session.close()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.put("/{user_id}/images", status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)],)
async def update_user(user_id: int, session: Session = Depends(get_session),file: UploadFile = File()):
    result = await uploadSVC.upload_image_user(session, file , user_id)
    session.close()
    return result

@router.put("/{user_id}", tags=["users"],status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def update_user(user_id: int, user: UserUpdate, session: Session = Depends(get_session)):
    db_user = userService.update_user(user_id=user_id, session=session, user=user)  
    session.close()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User updated successfully", "user": db_user}

@router.delete("/{user_id}", tags=["users"], status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(user_is_user)])
def delete_user(user_id: int, session: Session = Depends(get_session) ):
    db_user = userService.delete_user(session=session, user_id=user_id)
    session.close()
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")

@router.put("/ban/{user_id}", tags=["users", "modo", "admin"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_admin_or_modo)])
def ban_user(user_id: int, session: Session = Depends(get_session)):
    db_user = userService.ban_user(session=session, user_id=user_id)
    session.close()
    return {"message": "User banned successfully", "user": db_user}

@router.put("/unban/{user_id}", tags=["users", "modo", "admin"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_admin_or_modo)])
def unban_user(user_id: int, session: Session = Depends(get_session)):
    db_user = userService.unban_user(session=session, user_id=user_id)
    session.close()
    return {"message": "User unbanned successfully", "user": db_user}

