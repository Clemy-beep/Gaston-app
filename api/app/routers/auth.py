from sqlalchemy.orm import sessionmaker
from fastapi import APIRouter, Depends

from dependencies.database import engine, get_session

from services.auth_service import AuthService

from validators.auth_validator import LoginValidator as loginV, RegisterValidator as registerV

router = APIRouter()

Session = sessionmaker(bind=engine)

#services
authSVC = AuthService()

# get a recipe by id
@router.post("/login", tags=["auth"])
async def login(login: loginV, session: Session = Depends(get_session)):
    return authSVC.login(session, login.identifier, login.password)

@router.post("/register", tags=["auth"])
async def register(register: registerV, session: Session = Depends(get_session)):
    return authSVC.register(session, register)

