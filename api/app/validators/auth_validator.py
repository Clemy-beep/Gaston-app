from datetime import datetime
from typing import Optional
from pydantic import BaseModel


class LoginValidator(BaseModel):
    identifier: str
    password: str


class RegisterValidator(BaseModel):
    firstname: Optional[str] = None
    lastname: Optional[str] = None
    biography: Optional[str] = None
    # reporting: Optional[int] = None
    # roles: Optional[str] = None
    # created_at: Optional[datetime] = None
    email: str
    username: str
    password: str
