from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, func
from sqlalchemy.orm import mapped_column, relationship, Mapped

from dependencies.database import engine

from .base import Base
from ._utils import init_db


from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from entities.recipes import RecipeEntity


class StepRecipeEntity(Base):
    __tablename__ = "steps_recipes"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    recipe_id: Mapped[int] = mapped_column(ForeignKey("recipes.id"))

    position: Mapped[int] = mapped_column(Integer)

    name: Mapped[str] = mapped_column(String)
    description: Mapped[str] = mapped_column(Text)

    category: Mapped[Integer] = mapped_column(
        Integer
    )  #! TODO add category table or str enum

    timer: Mapped[int] = mapped_column(Integer, default=0)  # in seconds
    estimated_time: Mapped[int] = mapped_column(Integer, default=0)  # in seconds

    reports_number: Mapped[int] = mapped_column(Integer, default=0)

    created_at: Mapped[DateTime] = mapped_column(DateTime, server_default=func.now())
    updated_at: Mapped[DateTime] = mapped_column(
        DateTime, server_default=func.now(), onupdate=func.now()
    )

    recipe: Mapped["RecipeEntity"] = relationship(
        back_populates="steps", join_depth=1
    )  # bidirectional relationship


init_db(engine, Base)
