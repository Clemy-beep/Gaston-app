from dependencies.database import engine
from .base import Base
from ._utils import init_db
from datetime import date

from sqlalchemy import (
    Column, 
    Date,
    Integer,
    LargeBinary, 
    ARRAY,
    String, Text)

class UserEntity(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    firstname = Column(String, index=True)
    lastname = Column(String, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    biography = Column(Text)
    reporting = Column(Integer, default=0)
    roles = Column(ARRAY(String), default=["user"])
    password = Column(LargeBinary, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    token = Column(Text)
    createdAt = Column(Date, nullable=False, default=date.today())
    images = Column(Text, default=[])
 
init_db(engine, Base)
