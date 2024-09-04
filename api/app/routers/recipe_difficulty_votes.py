from fastapi import APIRouter, Depends, HTTPException, status
from validators.recipe_difficulty_vote_validator import RecipeDifficultyVoteCreate, RecipeDifficultyVoteUpdate
from dependencies.auth import user_is_user, current_user
from entities.recipe_difficulty_votes import RecipeDifficultyVoteEntity
from services.recipe_difficulty_vote_service import RecipeDifficultyVoteService
from services.auth_service import AuthService
from dependencies.database import Session, get_session




router = APIRouter()
recipe_difficulty_vote_service = RecipeDifficultyVoteService()
auth_service = AuthService()


@router.post("/", tags=["recipe_difficulty_votes"], status_code=status.HTTP_201_CREATED, dependencies=[Depends(user_is_user)])
def create_recipe_difficulty_vote(recipe_difficulty_vote_data: RecipeDifficultyVoteCreate, session: Session = Depends(get_session), user: dict = Depends(current_user)):
    try:
        # print(user.id)
        recipe_difficulty_vote_data.id_user = user.id
        new_recipe_difficulty_vote = recipe_difficulty_vote_service.create_recipe_difficulty_vote(session=session, recipe_difficulty_vote_data=recipe_difficulty_vote_data)
        return new_recipe_difficulty_vote
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to create recipe_difficulty_vote: {str(e)}")

@router.get("/{recipe_difficulty_vote_id}", tags=["recipe_difficulty_votes"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def read_recipe_difficulty_vote(recipe_difficulty_vote_id: int, session: Session = Depends(get_session)):
    db_recipe_difficulty_vote = recipe_difficulty_vote_service.get_recipe_difficulty_vote_by_id(session=session, recipe_difficulty_vote_id=recipe_difficulty_vote_id)
    if db_recipe_difficulty_vote is None:
        raise HTTPException(status_code=404, detail="recipe_difficulty_vote not found")
    return db_recipe_difficulty_vote

@router.put("/{recipe_difficulty_vote_id}", tags=["recipe_difficulty_votes"],status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def update_user(recipe_difficulty_vote_id: int, recipe_difficulty_vote_data: RecipeDifficultyVoteUpdate, session: Session = Depends(get_session)):
    db_recipe_difficulty_vote = recipe_difficulty_vote_service.update_recipe_difficulty_vote(recipe_difficulty_vote_id=recipe_difficulty_vote_id, session=session, recipe_difficulty_vote_data=recipe_difficulty_vote_data) 
    if db_recipe_difficulty_vote is None:
        raise HTTPException(status_code=404, detail="recipe_difficulty_vote not found")
    return {"message": "recipe_difficulty_vote updated successfully", "recipe_difficulty_vote": db_recipe_difficulty_vote}

@router.delete("/{recipe_difficulty_vote_id}", tags=["recipe_difficulty_votes"], status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(user_is_user)])
def delete_recipe_difficulty_vote(recipe_difficulty_vote_id: int, session: Session = Depends(get_session) ):
    db_user = recipe_difficulty_vote_service.delete_recipe_difficulty_vote_by_id(session=session, recipe_difficulty_vote_id=recipe_difficulty_vote_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
@router.get("/recipes/{id_recipe}", tags=["recipe_difficulty_votes"], status_code=status.HTTP_200_OK)
def get_recipe_difficulty_votes_by_recipe(id_recipe: int, session: Session = Depends(get_session)):
    db_recipe_difficulty_votes = recipe_difficulty_vote_service.get_recipe_difficulty_votes_by_recipe_id(session=session, id_recipe=id_recipe)
    if not db_recipe_difficulty_votes:
        raise HTTPException(status_code=404, detail="No recipe_difficulty_votes found for this recipe")
    return db_recipe_difficulty_votes

@router.get("/recipes/{id_recipe}/average-difficulty", tags=["recipe_difficulty_votes"], status_code=status.HTTP_200_OK)
def get_average_recipe_difficulty(id_recipe: int, session: Session = Depends(get_session)):
    try:
        average_difficulty = recipe_difficulty_vote_service.calculate_average_recipe_difficulty(session=session, id_recipe=id_recipe)
        return {"average_difficulty": average_difficulty}
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))