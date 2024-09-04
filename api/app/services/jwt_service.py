from abc import abstractmethod
from typing import Optional
from fastapi import Depends, HTTPException, Request, status
import jwt
from jwt.exceptions import PyJWTError
from datetime import datetime, timedelta
import logging
from ._singleton import Singleton

# Configuration de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

SECRET_KEY = "09d7ffb9ed32773c6a804abdf8e742c8df89e1eb2a9412ea6542f7c37b60bd95"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 7 * 24 * 60 # 7 jours

class JWTService():

    @staticmethod
    def encode(data: dict) -> str:
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        return encoded_jwt

    @staticmethod
    def decode(token: str) -> dict:
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
            return payload
        except PyJWTError as e:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Token verification failed"
            )
    
    @staticmethod
    def is_token_expired(request: Request) -> bool:
        token =  JWTService.extract_bearer_token(request)
        if token is None:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Token not found"
            )
        try:
            payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM], options={"verify_exp": True})
            return False 
        except jwt.ExpiredSignatureError:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Token expired"
            )
        except PyJWTError as e:
            logger.error(f"Error checking token expiration: {e}")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Not enough permissions"
            )

    @staticmethod
    def extract_bearer_token(request: Request) -> Optional[str]:
        auth_header = request.headers.get("Authorization")
        if auth_header is not None and auth_header.startswith("Bearer "):
            return auth_header.split(" ")[1]
        else:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Authorization token missing or malformed"
            )
        
    # @classmethod
    # def get_token_user_data(cls, request: Request) -> dict:
    #     try:
    #         token = cls.extract_bearer_token(request)
    #         payload = cls.decode(token)
    #         user_data = {'sub': payload.get('sub'), 'role': payload.get('role')}
    #         return user_data
    #     except PyJWTError as e:
    #         logger.error(f"Error extracting user data from token: {e}")
    #         raise HTTPException(
    #             status_code=status.HTTP_403_FORBIDDEN,
    #             detail="Could not validate credentials"
    #         )