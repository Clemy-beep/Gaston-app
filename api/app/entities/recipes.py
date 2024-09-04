from sqlalchemy import (
    Column,
    ForeignKey,
    ARRAY,
    Integer,
    SmallInteger,
    Numeric,
    String,
    DateTime,
    Interval,
    Table,
    Text,
)
from sqlalchemy.sql import func
from sqlalchemy.orm import mapped_column, relationship, Mapped
from typing import List, Optional

from dependencies.database import engine

from .base import Base
from .users import UserEntity  #! import to create a relationship with the user

# from .steps_recipes import StepRecipeEntity

from ._utils import init_db

from entities.tags import TagEntity

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from entities.steps_recipes import StepRecipeEntity

RecipeTagJoin = Table(
    "recipe_tag",
    Base.metadata,
    Column("recipe_id", ForeignKey("recipes.id")),
    Column("tag_id", ForeignKey("tags.id")),
)


class RecipeEntity(Base):
    __tablename__ = "recipes"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    id_user: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"))

    name: Mapped[str] = mapped_column(String)
    description: Mapped[str] = mapped_column(Text)

    difficulty: Mapped[int] = mapped_column(SmallInteger, nullable=True)
    estimated_time: Mapped[Optional[int]] = mapped_column(Interval, nullable=True)
    # price = mapped_column(Numeric(100, 0), default=0)
    report_number: Mapped[int] = mapped_column(Integer, default=0)
    images: Mapped[List[str]] = mapped_column(
        ARRAY(String), default=[]
    )  # url of the images

    steps: Mapped[List["StepRecipeEntity"]] = relationship(
        # order_by="StepRecipeEntity.position", cascade="all, delete", backref="recipe"
        order_by="StepRecipeEntity.position"
    )

    created_at: Mapped[DateTime] = mapped_column(DateTime, server_default=func.now())
    updated_at: Mapped[DateTime] = mapped_column(
        DateTime, server_default=func.now(), onupdate=func.now()
    )

    author: Mapped["UserEntity"] = relationship(
        "UserEntity", foreign_keys=[id_user], join_depth=1
    )
    tags: Mapped[List["TagEntity"]] = relationship(
        # secondary=RecipeTagJoin, backref="recipes" , cascade="all, delete"
        secondary=RecipeTagJoin, backref="recipes"
    )
    #! TODO ingredients

init_db(engine, Base)
