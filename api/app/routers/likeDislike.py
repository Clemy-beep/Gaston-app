from fastapi import APIRouter, Depends
from sqlalchemy.orm import sessionmaker
from dependencies.database import engine
from services.vote_service import VoteService
from pydantic import BaseModel
from typing import Optional

router = APIRouter()

Session = sessionmaker(bind=engine)

class VoteCreate(BaseModel):
    user_id: int
    recipe_id: int
    value: Optional[bool] = None  # Allowing None as a valid value

class VoteResponse(BaseModel):
    recipe_id: int
    vote_count: int
# TODO a ajouté user_is_user
@router.post("/vote/", tags=["likeDislike"], response_model=VoteResponse)
async def vote(vote: VoteCreate):
    vote_count = VoteService.vote(Session, vote.user_id, vote.recipe_id, vote.value)
    return {"recipe_id": vote.recipe_id, "vote_count": vote_count}
