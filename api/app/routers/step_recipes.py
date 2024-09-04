from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session


from dependencies.database import get_session
from dependencies.auth import current_user, user_is_user

from entities.users import UserEntity

from services.step_recipe_service import StepRecipeService
from services.recipe_service import RecipeService

from validators.step_recipe_validator import StepRecipeAddValidator


router = APIRouter()

# services
recipeSvc = RecipeService()
stepRecipeSvc = StepRecipeService()


@router.get(
    "/recipes/{id_recipe}/steps",
    tags=["steps"],
    dependencies=[Depends(user_is_user)],
)
async def get_steps_recipe(
    id_recipe: int,
    session: Session = Depends(get_session),
):
    """get steps of a recipe"""
    steps = stepRecipeSvc.get_steps_recipe(session, id_recipe)
    session.close()
    return steps


@router.post(
    "/recipes/{id_recipe}/steps",
    tags=["steps"],
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(user_is_user)],
)
async def create_steps_recipe(
    id_recipe: int,
    steps: list[StepRecipeAddValidator] | StepRecipeAddValidator,
    user: UserEntity = Depends(current_user),
    session: Session = Depends(get_session),
):
    """add step(s) to a recipe (only the author)
    - if the recipe exists do nothing
    - if the recipe does not exist do nothing
    - if the recipe exists and the steps are empty add the steps to the recipe
    """

    stepRecipeSvc.create_steps_recipe(session, id_recipe, steps, user)
    session.close()
    return "ok"


@router.post(
    "/recipes/{id_recipe}/steps/{id_step}",
    tags=["steps"],
    status_code=status.HTTP_201_CREATED,
    dependencies=[Depends(user_is_user)],
)
async def add_step_recipe(
    id_recipe: int,
    id_step: int,
    before: bool,
    step: StepRecipeAddValidator,
    user: UserEntity = Depends(current_user),
    session: Session = Depends(get_session),
):
    """add a step to a recipe (only the author)
    - if the recipe exists and no step exists do error
    - if the recipe exists and the step exists add the step before or after the step
    """
    stepRecipeSvc.add_step_recipe(session, step, user, id_recipe, id_step, before)
    session.close()
    return "ok"


@router.put(
    "/recipes/{id_recipe}/steps/{id_step}",
    tags=["steps"],
    status_code=status.HTTP_200_OK,
    dependencies=[Depends(user_is_user)],
)
async def update_step_recipe(
    id_recipe: int,
    id_step: int,
    step: StepRecipeAddValidator,
    user: UserEntity = Depends(current_user),
    session: Session = Depends(get_session),
):
    """update a step of a recipe (only the author)"""
    stepRecipeSvc.update_step_recipe(session, step, user, id_recipe, id_step)
    session.close()
    return "ok"


@router.delete(
    "/recipes/{id_recipe}/steps/{id_step}",
    tags=["steps"],
    status_code=status.HTTP_204_NO_CONTENT,
    dependencies=[Depends(user_is_user)],
)
def delete_step_recipe(
    id_recipe: int,
    id_step: int,
    user: UserEntity = Depends(current_user),
    session: Session = Depends(get_session),
):
    """delete a step of a recipe (only the author)"""
    stepRecipeSvc.delete_step_recipe(session, user, id_recipe, id_step)
    session.close()
    return "ok"
