import os
from typing import Optional
import uuid

from validators.recipe_validator import RecipeAddValidator, RecipeSearchValidator, RecipeValidator

from dependencies.database import get_session
from dependencies.auth import current_user, user_is_user

from services.recipe_service import RecipeService
from services.user_service import UserService

from entities.recipes import RecipeEntity
from entities.users import UserEntity
from services.upload_image_service import UploadImageService

from sqlalchemy.orm import Session

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, dependencies, status

router = APIRouter()

# Session = sessionmaker(bind=engine)

#services
userSvc = UserService()
recipeSvc = RecipeService()
uploadSVC = UploadImageService()

# get a recipe by namme
@router.get("/search", tags=["recipes"])
async def recipe_by_name(recipes: str , author : Optional[str] = None):
    print(recipes)
    session = Session()

    recipe = recipeSvc.recipe_by_name(session, recipe_name= recipes, recipe_author=author)
    session.close()
    return recipe

# get a recipe by id
@router.get("/{id}", tags=["recipes"], dependencies=[Depends(user_is_user)])
async def get_recipe_by_id(id: int, session: Session = Depends(get_session)):
    recipe = recipeSvc.recipe_by_id(session, id)
    session.close()
    return recipe

@router.post("/search", tags=["recipes"], dependencies=[Depends(user_is_user)])
async def search_recipe(recipeSearch: RecipeSearchValidator, session: Session = Depends(get_session)):
    recipes = recipeSvc.search(session, recipeSearch)
    session.close()
    return recipes

@router.post("/", tags=["recipes"], status_code=status.HTTP_201_CREATED, dependencies=[Depends(user_is_user)])
async def create_recipe(
    recipe: RecipeAddValidator =  Form(...),
    session: Session = Depends(get_session), 
    user: UserEntity = Depends(current_user), 
    file: UploadFile = File(default=None)
):
    _recipe = recipeSvc.create_recipe(session, recipe, user)
    if file:
        _recipe.images = [await uploadSVC.upload_image_recipe(session, file, _recipe.id)]
    session.close()
    return _recipe

@router.put("/{id}", tags=["recipes"], dependencies=[Depends(user_is_user)])
async def update_recipe(id: int, recipe: RecipeValidator, session: Session = Depends(get_session)):
    recipe.id = id # hola petit margoulin
    recipe = recipeSvc.update_recipe(session, recipe)
    session.close()
    return recipe

@router.put("/{id}/images", tags=["recipes"],dependencies =[Depends(user_is_user)])
async def update_recipe_image(recipe_id: int,file: UploadFile = File(), session: Session = Depends(get_session)):
    result = await uploadSVC.upload_image_recipe(session, file , recipe_id)
    session.close()
    return result

@router.delete("/{id}", tags=["recipes"], status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(user_is_user)])
async def delete_recipe(id: int, session: Session = Depends(get_session), user: UserEntity = Depends(current_user)):
    recipe = recipeSvc.delete_recipe(session, id, user, userSvc.has_role_admin(user))
    session.close()
    return recipe
