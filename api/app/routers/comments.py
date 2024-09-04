from fastapi import APIRouter, Depends, HTTPException, Request, status
from validators.comment_validator import CommentCreate, CommentUpdate
from dependencies.auth import current_user, user_is_user
from entities.comments import CommentEntity
from entities.users import UserEntity
from services.comment_service import CommentService
from services.user_service import UserService
from dependencies.database import Session, engine, get_session




router = APIRouter()
comment_service = CommentService()
userSvc = UserService()

# @router.get("/all", tags=["users"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
# def get_all_users(session: Session = Depends(get_session)):
#     db_users = userService.get_all_users(session=session)
#     session.close()
#     if db_users is None or len(db_users) == 0:
#         raise HTTPException(status_code=404, detail="No users found")
#     return db_users

@router.get("/{comment_id}", tags=["comments"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def get_comment_by_id(comment_id: int, session: Session = Depends(get_session)):
    db_comment = comment_service.get_comment_by_id(session=session, comment_id=comment_id)
    session.close()
    if db_comment is None:
        raise HTTPException(status_code=404, detail="Comment not found")
    return db_comment

@router.get("/recipes/{id_recipe}", tags=["recipes", "comments"], status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def get_comments_by_recipe(id_recipe: int, session: Session = Depends(get_session)):
    db_comments = comment_service.get_comments_by_recipe_id(session=session, id_recipe=id_recipe)
    session.close()
    if not db_comments:
        raise HTTPException(status_code=404, detail="No comments found for this recipe")
    return db_comments

@router.post("/", tags=["comments"], status_code=status.HTTP_201_CREATED, dependencies=[Depends(user_is_user)])
def create_comment(comment_data: CommentCreate, session: Session = Depends(get_session), user: UserEntity = Depends(current_user)):
    try:
        new_comment = comment_service.create_comment(session=session, comment_data=comment_data)
        session.commit()
        return new_comment
    except Exception as e:
        session.rollback()
        raise HTTPException(status_code=400, detail=f"Failed to create comment: {str(e)}")

@router.put("/{comment_id}", tags=["comments"],status_code=status.HTTP_200_OK, dependencies=[Depends(user_is_user)])
def update_comment(comment_id: int, comment_data: CommentUpdate, session: Session = Depends(get_session), user: UserEntity = Depends(current_user)):
    db_comment = comment_service.update_comment(comment_id=comment_id, session=session, comment_data=comment_data, user=user) 
    session.close()
    if db_comment is None:
        raise HTTPException(status_code=404, detail="Comment not found")
    return {"message": "Comment updated successfully", "comment": db_comment}

@router.delete("/{comment_id}", tags=["comments", "modo", "admin"], status_code=status.HTTP_204_NO_CONTENT, dependencies=[Depends(user_is_user)])
def delete_comment(comment_id: int, session: Session = Depends(get_session), user: UserEntity = Depends(current_user)):
    db_comment = comment_service.delete_comment_by_id(session=session, comment_id=comment_id, user=user, is_modo_or_admin=userSvc.has_role_admin_or_modo(user))
    session.close()
    if db_comment is None:
        raise HTTPException(status_code=404, detail="Comment not found")