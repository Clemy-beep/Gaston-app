from fastapi import HTTPException
from ._singleton import Singleton
from dependencies.database import Session
from validators.comment_validator import CommentCreate, CommentUpdate
from entities.comments import CommentEntity
from entities.users import UserEntity


class CommentService(metaclass=Singleton):
    def __init__(self):
        pass

    def get_comment_by_id(self, session: Session, comment_id: int):
        db_comment = session.query(CommentEntity).filter(CommentEntity.id == comment_id).first()
        return db_comment

    def create_comment(self, session: Session, comment_data: CommentCreate):
        db_comment = CommentEntity(**comment_data.model_dump(exclude_none=True, 
                                                            exclude_unset=True,
                                                            exclude={'reporting'}))
        session.add(db_comment)
        session.commit()
        session.refresh(db_comment)
        return db_comment

    def update_comment(self, comment_id: int, session: Session, comment_data: CommentUpdate, user: UserEntity):
        db_comment = session.query(CommentEntity).filter(CommentEntity.id == comment_id).first()
        print("dbcomeemnt", db_comment)
        if db_comment: # check authorisation
            if db_comment.id_user != user.id:
                raise HTTPException(status_code=403, detail="Not enough permissions")
            db_comment.comment = comment_data.model_dump(include={'comment'})['comment']
            session.commit()
            session.refresh(db_comment)
            return db_comment 
        return None 

    def delete_comment_by_id(self, session: Session, comment_id: int, user: UserEntity, is_modo_or_admin=False):
        db_comment = session.query(CommentEntity).filter(CommentEntity.id == comment_id).first()
        if db_comment:
            if not is_modo_or_admin: # check authorisation
                if db_comment.id_user != user.id:
                    raise HTTPException(status_code=403, detail="Not enough permissions")
            session.delete(db_comment)
            session.commit()
            return True
        return False 
    
    def get_comments_by_recipe_id(self, session: Session, id_recipe: int):
        comments = session.query(CommentEntity).filter(CommentEntity.id_recipe == id_recipe).all()
        return comments                                                     