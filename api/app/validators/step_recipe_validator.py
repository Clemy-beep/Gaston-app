from typing import Optional
from pydantic import BaseModel, Field


class StepRecipeAddValidator(BaseModel):
    name: str
    description: str

    category: int = Field(
        ..., example="1", description="Category of the step"
    )  #! TODO add category table

    timer: Optional[int] = Field(
        None, example="2", description="timer for the step in seconds", ge=0
    )
    estimated_time: Optional[int] = Field(
        None,
        example="2",
        description="Estimated time for the step in seconds",
        Optional=True,
        ge=0,
    )


class StepRecipesAddValidator(BaseModel):
    steps: list[StepRecipeAddValidator]
