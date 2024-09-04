from dependencies.database import engine

from .base import Base

from ._utils import init_db

from sqlalchemy import (
    Column,
    Integer,
    String,
)
from sqlalchemy.orm import mapped_column, relationship, Mapped

from ._utils import init_db


class TagEntity(Base):
    __tablename__ = "tags"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)

    color_id: Mapped[str] = mapped_column(String)
    name: Mapped[str] = mapped_column(String)


init_db(engine, Base)
