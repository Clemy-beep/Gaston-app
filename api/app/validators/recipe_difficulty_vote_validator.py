from pydantic import BaseModel, conint
from typing import Optional
from datetime import datetime


class RecipeDifficultyVoteBase(BaseModel):
    difficulty: conint(ge=0, le=5)
    id_user: int
    id_recipe: int

class RecipeDifficultyVoteCreate(RecipeDifficultyVoteBase):
    id_user: Optional[int] = None
    id_recipe: Optional[int] = None
    difficulty: conint(ge=0, le=5)

class RecipeDifficultyVoteUpdate(BaseModel):
    difficulty: conint(ge=0, le=5)

class RecipeDifficultyVoteInDB(RecipeDifficultyVoteBase):
    id: int
    difficulty: conint(ge=0, le=5)
    id_user: int
    id_recipe: int
    created_at: datetime
