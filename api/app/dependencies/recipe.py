from typing import Annotated
from fastapi import Depends, HTTPException


from dependencies.database import Session, get_session
from dependencies.auth import current_user

from entities.users import UserEntity
from entities.recipes import RecipeEntity

def recipe_by_id(id: int, session:Session = Depends(get_session)):
    recipe =  session.query(RecipeEntity).filter(RecipeEntity.id == id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return recipe
    

def is_author(recipe: Annotated[RecipeEntity, Depends(recipe_by_id)], user: Annotated[UserEntity, Depends(current_user)]):
        if recipe.id_user != user.id:
            return False
        return True