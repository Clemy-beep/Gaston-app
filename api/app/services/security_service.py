from .user_service import UserService
from fastapi.security import OAuth2PasswordBearer
from fastapi import HTTPException, Depends, Security, status
from typing import Callable, Optional
from ._singleton import Singleton


from .jwt_service import JWTService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class SecurityService(metaclass=Singleton):
    def __init__(self, userSvc: UserService = UserService()):
        self._userSvc = userSvc


    def get_current_user(self, token: str = Depends(oauth2_scheme)) -> Optional[dict]:
        token_data = JWTService.decode(token).get("sub")
        if token_data:
            user = self._userSvc.get_user_by_username(token_data)
            return user
        else:
            return None
