from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class CommentBase(BaseModel):
    comment: str
    id_user: int
    id_recipe: int



class CommentCreate(CommentBase):
    id_user: Optional[int] = None
    id_recipe: Optional[int] = None
    comment: str 


class CommentUpdate(BaseModel):
    comment: str 


class CommentInDB(CommentBase):
    id: int
    comment: str
    id_user: int
    id_recipe: int
    id_step_recipe: Optional[int] = None
    created_at: datetime
    reporting: int