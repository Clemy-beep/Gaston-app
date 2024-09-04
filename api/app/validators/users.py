from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class UserBase(BaseModel):
    email: str
    username: str

class UserCreate(UserBase):
    password: str
    firstname: Optional[str] = None
    lastname: Optional[str] = None
    biography: Optional[str] = None
    reporting: Optional[int] = None
    roles: Optional[str] = None

class UserUpdate(BaseModel):
    firstname: Optional[str] = None
    lastname: Optional[str] = None
    biography: Optional[str] = None
    reporting: Optional[int] = None
    roles: Optional[str] = None

# used ?
class UserInDB(UserBase):
    id: int
    firstname: Optional[str] = None
    lastname: Optional[str] = None
    biography: Optional[str] = None
    reporting: bool
    roles: Optional[str] = None
    created_at: datetime

    class Config:
        orm_mode = True