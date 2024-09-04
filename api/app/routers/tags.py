from sqlalchemy.orm import sessionmaker

from dependencies.database import engine
from dependencies.auth import user_is_admin_or_modo

from services.recipe_service import RecipeService
from services.tag_service import TagService

from validators.tag_validator import TagAddValidator, TagUpdateValidator

from fastapi import APIRouter, Depends, HTTPException

router = APIRouter()

# #
# @router.get("/", tags=["recipes"])
# async def all_recipes():
#     return [{"data": "Rick"}, {"data": "Morty"}, {"data": "C'est un scandal !"}]

Session = sessionmaker(bind=engine)

# services
tagSvc = TagService()

@router.get("/", tags=["tags"])
async def get_all_tags():
    session = Session()
    try:
        tags = tagSvc.get_all_tags(session)
        return tags
    finally:
        session.close()

@router.get("/{id}", tags=["tags"])
async def get_tag_by_id(id: int):
    session = Session()
    tag = tagSvc.get_tag_by_id(session, id)
    session.close()
    return tag

@router.post("/", tags=["tags","modo","admin"], dependencies=[Depends(user_is_admin_or_modo)])
async def create_tag(tag: TagAddValidator):
    session = Session()
    tag_db = tagSvc.create_tag(session, tag)
    session.close()
    return tag_db


# Endpoint pour mettre à jour un tag par ID
@router.put("/{id}", tags=["tags","modo","admin"], dependencies=[Depends(user_is_admin_or_modo)])
async def update_tag(id: int, tag: TagUpdateValidator):
    session = Session()
    tag.id = id
    tag = tagSvc.update_tag(session, tag)
    session.close()
    return tag


# Endpoint pour supprimer un tag par ID
@router.delete("/{id}", tags=["tags","modo","admin"], dependencies=[Depends(user_is_admin_or_modo)])
def delete_tag(id: int):
    session = Session()

    deleted_tag = tagSvc.delete_tag(session, id)
    if deleted_tag is None:
        raise HTTPException(status_code=404, detail="Tag not found")
    return deleted_tag
