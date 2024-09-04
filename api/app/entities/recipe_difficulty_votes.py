from sqlalchemy import Column, ForeignKey, Integer, SmallInteger, Text, Date
from sqlalchemy.orm import relationship
from .base import Base
from datetime import datetime

class RecipeDifficultyVoteEntity(Base):
    __tablename__ = "recipe_difficulty_votes"
    id = Column(Integer, primary_key=True, index=True)
    id_user = Column(Integer, ForeignKey('users.id'), nullable=True)
    id_recipe = Column(Integer, ForeignKey('recipes.id'), nullable=True)
    created_at = Column(Date, nullable=False, default=datetime.now())
    difficulty = Column(SmallInteger, default=0)

    creator = relationship("UserEntity", foreign_keys=[id_user])