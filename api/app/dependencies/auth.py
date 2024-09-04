#ext imports
from typing import Annotated
from fastapi import Depends, HTTPException, Request, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials


#app imports
from services.user_service import UserService
from dependencies.database import Session, get_session
from entities.users import UserEntity
from services.jwt_service import JWTService

jwtSvc = JWTService()
userSvc = UserService()

security = HTTPBearer()

def valid_jwt(credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)], request: Request):
    if credentials:
        if not credentials.scheme == "Bearer":
            raise HTTPException(status_code=403, detail="Invalid authentication scheme.")
        tmp = jwtSvc.decode(credentials.credentials)
        if not tmp:
            raise HTTPException(status_code=403, detail="Invalid token or expired token.")
        return tmp
    else:
        raise HTTPException(status_code=403, detail="Invalid authorization code.")

def current_user(jwt:dict = Depends(valid_jwt), session = Depends(get_session))-> UserEntity: 
    user = userSvc.get_user_by_username(session, jwt.get("sub"))
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")
    if userSvc.has_role_banned(user):
        raise HTTPException(status_code=403, detail="User is banned.")
    return user

def user_is_user(user: Annotated[UserEntity, Depends(current_user)]):
    user_is_not_banned(user)
    if user and user.roles and userSvc.has_role_user(user):
        return True
    else:
        raise HTTPException(status_code=403, detail="Not enough permissions.")
    
def user_is_not_banned(user: Annotated[UserEntity, Depends(current_user)]):
    if user and user.roles and userSvc.has_role_banned(user):
        raise HTTPException(status_code=403, detail="User is banned.")
    else:
        return True
    
def user_is_admin(user: Annotated[UserEntity, Depends(current_user)]):
    user_is_not_banned(user)
    if user and user.roles and userSvc.has_role_admin(user):
        return True
    else:
        raise HTTPException(status_code=403, detail="Not enough permissions.")
    
def user_is_modo(user: Annotated[UserEntity, Depends(current_user)]):
    user_is_not_banned(user)
    if user and user.roles and userSvc.has_role_modo(user):
        return True
    else:
        raise HTTPException(status_code=403, detail="Not enough permissions.")
    
def user_is_admin_or_modo(user: Annotated[UserEntity, Depends(current_user)]):
    user_is_not_banned(user)
    if user and user.roles and userSvc.has_role_admin_or_modo(user):
        return True
    else:
        raise HTTPException(status_code=403, detail="Not enough permissions.")