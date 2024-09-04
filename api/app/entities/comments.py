from sqlalchemy import Column, ForeignKey, Integer, Text, Date
from sqlalchemy.orm import relationship
from .base import Base
from datetime import datetime

class CommentEntity(Base):
    __tablename__ = "comments"
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_user = Column(Integer, ForeignKey('users.id'), nullable=True)
    id_recipe = Column(Integer, ForeignKey('recipes.id'), nullable=True)
    #! TODO implement step_recipies id_step_recipes = Column(Integer, ForeignKey('step_recipes.id'), nullable=True)
    reporting = Column(Integer, default=0)
    comment = Column(Text, nullable=False)
    createdAt = Column(Date, nullable=False, default=datetime.now())

    creator = relationship("UserEntity", foreign_keys=[id_user])
