from typing import Optional
from pydantic import BaseModel, Field

from validators.pagination_validator import PaginationValidator


class TagValidator(BaseModel):
    id: int = Field(..., example="2", description="ID  with the tag")
    name: str = Field(..., example="thai", description="Name of the tag")
    color: str = Field(..., example="blue", description="Color of the tag")


class TagAddValidator(BaseModel):
    # id: int = Field(..., example="2", description="ID  with the tag")

    color_id: str = Field(
        ..., example="blue", description="Color ID associated with the tag"
    )
    name: str = Field(..., example="Important", description="Name of the tag")


class TagUpdateValidator(BaseModel):
    id: int = Field(..., example="2", description="ID  with the tag")

    color_id: str = Field(
        ..., example="red", description="Color ID associated with the tag"
    )
    name: str = Field(..., example="Updated Tag", description="Updated name of the tag")


class TagSearchValidator(BaseModel):
    names: Optional[list[str]] = Field(
        None,
        example='["tag","couscous","kebab"]',
        description="List of names to search in the tags",
    )
    ids: Optional[list[int]] = Field(
        None, example="[1,2,3]", description="List of IDs to search in the tags"
    )
    # pagination: PaginationValidator = Field(..., example="{'limit':10,'offset':0}", description="Pagination object")
