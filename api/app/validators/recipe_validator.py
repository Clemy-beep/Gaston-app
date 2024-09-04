from typing import Any, List, Optional, Union
from pydantic import BaseModel, Field, model_validator
from pydantic_core import from_json
from sqlalchemy import Interval

from validators.pagination_validator import PaginationValidator
from validators.ingredient_validator import ingredientAddValidator
from validators.tag_validator import TagSearchValidator, TagValidator
from validators.step_recipe_validator import StepRecipeAddValidator

class RecipeAddValidator(BaseModel):
    # id_user: Optional[int] = None

    name: Optional[str] = None
    description: Optional[str] = None

    difficulty: Optional[int] = None
    estimated_time: Optional[str] = Field(
        None,
        example="2",
        description="Estimated time for the recipe in seconds",
        Optional=True,
    )
    # price: Optional[float] = None

    stepRecipe: Optional[List[StepRecipeAddValidator]] = None
    tags: Optional[TagSearchValidator] = None
    ingredients: Optional[List[ingredientAddValidator]] = None
    images: Optional[List[str]] = None
    
    @model_validator(mode="before")
    @classmethod
    def convert_json_string_into_dictionary(cls, data: Any) -> Any:
        if isinstance(data, str):
                return from_json(data)
        return data

 
class RecipeValidator(RecipeAddValidator):
    id: Optional[int] = None


class RecipeWithValidator(BaseModel):
    tags: Optional[bool] = True
    ingredients: Optional[bool] = True
    steps: Optional[bool] = True


class RecipeSearchValidator(BaseModel):
    text: Optional[str] = None
    ids: Optional[List[int]] = None
    tags: Optional[List[Union[int, str]]] = None
    author: Optional[Union[int, str]] = None
    ingredients: Optional[List[Union[int, str]]] = None
    pagination: Optional[PaginationValidator] = None

    with_extra: Optional[RecipeWithValidator] = RecipeWithValidator()
