from fastapi import Depends, HTTPException

from sqlalchemy import insert
from sqlalchemy.orm import Session

from dependencies.auth import current_user
from dependencies.recipe import recipe_by_id, is_author

from entities.users import UserEntity
from entities.steps_recipes import (
    StepRecipeEntity,
)  # recipe need to be added before step recipe


from validators.step_recipe_validator import StepRecipeAddValidator

from ._singleton import Singleton

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from services.recipe_service import RecipeService


class StepRecipeService(metaclass=Singleton):
    def _prepare_step_recipe(
        self, step: StepRecipeAddValidator, recipe_id: int, position: int
    ):
        return StepRecipeEntity(
            recipe_id=recipe_id,
            position=position,
            name=step.name,
            description=step.description,
            category=step.category,
            estimated_time=step.estimated_time,
            timer=step.timer,
        )

    def get_steps_recipe(self, session: Session, id_recipe: int):
        """get steps of a recipe"""
        return (
            session.query(StepRecipeEntity)
            .filter(StepRecipeEntity.recipe_id == id_recipe)
            .all()
        )

    def get_step_recipe(self, session: Session, id_recipe: int, id_step: int):
        """get a step of a recipe"""
        return (
            session.query(StepRecipeEntity)
            .filter(
                StepRecipeEntity.recipe_id == id_recipe, StepRecipeEntity.id == id_step
            )
            .first()
        )

    def create_steps_recipe(
        self,
        session: Session,
        id_recipe: int,
        steps: list[StepRecipeAddValidator] | StepRecipeAddValidator,
        user: UserEntity,
    ):
        """add step(s) to a recipe if author"""
        # get recipe
        recipe = recipe_by_id(id_recipe, session)
        
        # check authorisation
        if not is_author(recipe, user):
            raise HTTPException(status_code=403, detail="Not enough permissions")

        # if step in steps
        if recipe.steps:
            raise HTTPException(status_code=409, detail="Step already exists")

        # add steps
        if isinstance(steps, list):
            tmp = []
            for position, step in enumerate(steps):
                tmp.append(self._prepare_step_recipe(step, id_recipe, position))
            session.add_all(tmp)
        else:
            tmp = self._prepare_step_recipe(steps, user, id_recipe, 0)
            session.add(tmp)
        session.commit()
        return True

    def add_step_recipe(
        self,
        session: Session,
        step: StepRecipeAddValidator,
        user: UserEntity,
        id_recipe: int,
        id_step: int,
        before: bool,
    ):
        """add a step to a recipe if author
        if step is out of range do nothing"""
        # get recipe
        recipe = recipe_by_id(id_recipe, session)
        
        # check authorisation
        if not is_author(recipe, user):
            raise HTTPException(status_code=403, detail="Not enough permissions")

        steps = recipe.steps
        if id_step < 0 or id_step > len(steps):
            return HTTPException(status_code=400, detail="Step out of range")

        # add step
        position = id_step if before else id_step + 1
        # upsate position of other steps
        for _step in recipe.steps:
            if _step.position >= position:
                _step.position += 1
        step = self._prepare_step_recipe(step, id_recipe, position)
        session.add(step)
        session.commit()

        return "ok"

    def update_step_recipe(
        self,
        session: Session,
        stepInput: StepRecipeAddValidator,
        user: UserEntity,
        id_recipe: int,
        id_step: int,
    ):
        """update a step of a recipe if author"""
        # get recipe
        recipe = recipe_by_id(id_recipe, session)
        
        # check authorisation
        if not is_author(recipe, user):
            raise HTTPException(status_code=403, detail="Not enough permissions")

        # get step
        step = self.get_step_recipe(session, id_recipe, id_step)

        if not step:
            raise HTTPException(status_code=404, detail="Step not found")

        # update step
        step.name = stepInput.name
        step.description = stepInput.description
        step.category = stepInput.category
        step.estimated_time = stepInput.estimated_time
        step.timer = stepInput.timer
        session.commit()

        return "ok"

    def delete_step_recipe(
        self, session: Session, user: UserEntity, id_recipe: int, id_step: int
    ):
        """delete a step of a recipe if author"""
        # get recipe
        recipe = recipe_by_id(id_recipe, session)
        
        # check authorisation
        if not is_author(recipe, user):
            raise HTTPException(status_code=403, detail="Not enough permissions")

        # get steps
        steps = self.get_steps_recipe(session, id_recipe)

        # step not found
        if not steps or not any(step.position == id_step for step in steps):
            raise HTTPException(status_code=404, detail="Step not found")

        deleted = False
        for step in steps:
            if step.id == id_step:
                session.delete(step)
                deleted = True
            elif deleted:
                step.position -= 1
        session.commit()

        return "ok"
