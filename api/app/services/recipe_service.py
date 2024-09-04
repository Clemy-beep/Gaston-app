import json
from urllib import request
from fastapi import File, HTTPException, Request, UploadFile
from sqlalchemy.orm import Session, Query, selectinload

from entities.recipes import RecipeEntity
from entities.users import UserEntity

from services.pagination import paginate
from services.step_recipe_service import StepRecipeService
from services.tag_service import TagService
from services.user_service import UserService

from validators.recipe_validator import (
    RecipeAddValidator,
    RecipeSearchValidator,
    RecipeValidator,
    RecipeWithValidator,
)

from ._singleton import Singleton

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from services.recipe_service import StepRecipeService
    from services.tag_service import TagService


class RecipeService(metaclass=Singleton):
    def __init__(self, stepRecipeSvc:StepRecipeService = StepRecipeService(), tagSvc:TagService = TagService()):
        self._stepRecipeSvc = stepRecipeSvc
        self._tagSvc = tagSvc
        

    # def is_author(self, session: Session, recipe: RecipeEntity, user: UserEntity):
    #     if recipe.id_user != user.id:
    #         return False
    #     return True

    def _by_text(self, session: Query[RecipeEntity], text: str):
        return session.filter(
            RecipeEntity.name.ilike(f"%{text}%")
        )  #! TODO very base need to be improved and moved to a full text search

    def _by_ids(self, session: Query[RecipeEntity], ids: list[int]):
        return session.filter(RecipeEntity.id.in_(ids))

    def _by_tags(self, session: Query[RecipeEntity], tags: list[int | str]):
        byIndex = []
        byName = []
        for tag in tags:
            if isinstance(tag, int):
                byIndex.append(tag)
            else:
                byName.append(tag)
        if byIndex:
            pass  #! TODO search by tags index
        if byName:
            pass  #! TODO search by tags name
        pass

    def _by_author(self, session: Query[RecipeEntity], author: int | str):
        if isinstance(author, int):
            return session.filter(RecipeEntity.id_user == author)
        else:
            pass  #! TODO search by username (user service needed)

    def _by_ingredients(
        self, session: Query[RecipeEntity], ingredients: list[int | str]
    ):
        byIndex = []
        byName = []
        for ingredient in ingredients:
            if isinstance(ingredient, int):
                byIndex.append(ingredient)
            else:
                byName.append(ingredient)
        if byIndex:
            pass  #! TODO search by ingredients index
        if byName:
            pass  #! TODO search by ingredients name

    def _with_extra(
        self, session: Query[RecipeEntity], with_extra: RecipeWithValidator
    ):
        # if with_extra.tags:
        #     session = session.options(selectinload(RecipeEntity.tags))
        # if with_extra.ingredients:
        #     session = session.options(selectinload(RecipeEntity.ingredients))
        if with_extra.steps:
            session = session.options(selectinload(RecipeEntity.steps))
        return session

    def recipe_by_id(self, session: Session, recipe_id: int):
        db_recipe = session.query(RecipeEntity).filter(RecipeEntity.id == recipe_id).first()
        db_recipe.steps  # force load of steps
        db_recipe.tags  # force load of tags
        return db_recipe

    def recipe_by_name(
        self, session: Session, recipe_name: str = None, recipe_author: str = None
    ):
        query = session.query(RecipeEntity).join(
            UserEntity, RecipeEntity.id_user == UserEntity.id
        )
        query = query.filter(RecipeEntity.name.ilike(f"%{recipe_name}%"))
        if recipe_author:
            query = query.filter(UserEntity.username.ilike(f"%{recipe_author}%"))
        return query.all()

    def search(self, session: Session, recipeSearch: RecipeSearchValidator):
        search = session.query(RecipeEntity)
        if recipeSearch.text:
            search = self._by_text(search, recipeSearch.text)
        if recipeSearch.tags:
            search = self._by_tags(search, recipeSearch.tags)
        if recipeSearch.author:
            search = self._by_author(search, recipeSearch.author)
        if recipeSearch.ingredients:
            search = self._by_ingredients(search, recipeSearch.ingredients)

        if recipeSearch.with_extra:
            search = self._with_extra(search, recipeSearch.with_extra)

        return paginate(search, recipeSearch.pagination).all()

    def create_recipe(
        self, session: Session, recipe: RecipeAddValidator, user: UserEntity
    ):
        db_recipe = RecipeEntity(
            **recipe.model_dump(
                exclude_none=True,
                exclude_unset=True,
                exclude={"stepRecipe", "tags", "ingredients"},
            ),
            id_user=user.id,
        )
        session.add(db_recipe)
        session.commit()
        session.refresh(db_recipe)
        # stepRecipe
        if recipe.stepRecipe:
            self._stepRecipeSvc.create_steps_recipe(
                session, db_recipe.id, recipe.stepRecipe, user
            )
        # tags
        if recipe.tags:
            db_recipe.tags = self._tagSvc.search_tags(session, recipe.tags)

        #! TODO ingredients
        session.commit()
        session.refresh(db_recipe)
        db_recipe.steps  # force load of steps
        db_recipe.tags  # force load of tags
        return db_recipe

    def delete_recipe(self, session: Session, recipe_id: int, user: UserEntity, is_admin: bool = False):
        if not is_admin:
            if recipe_id != user.id:
                raise HTTPException(status_code=403, detail="Not enough permissions")
        recipe = (
            session.query(RecipeEntity).filter(RecipeEntity.id == recipe_id).first()
        )
        if not recipe:
            raise HTTPException(status_code=404, detail="Recipe not found")
        session.delete(recipe)
        session.commit()
        return True

    def update_recipe(self, session: Session, recipe: RecipeAddValidator):
        #! TODO only admin can change the author (user_id)
        tmp = recipe.model_dump(
            exclude_none=True,
            exclude_unset=True,
            exclude={"stepRecipe", "tags", "ingredients", "id"},
        )
        session.query(RecipeEntity).filter(RecipeEntity.id == recipe.id).update(tmp)
        #! TODO stepRecipe
        #! TODO tags
        #! TODO ingredients
        session.commit()
        return self.recipe_by_id(session, recipe.id)
