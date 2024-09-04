from sqlalchemy.orm import Session

from validators.tag_validator import TagAddValidator, TagUpdateValidator
from entities.vote import VoteEntity
from ._singleton import Singleton

class VoteService(metaclass=Singleton):
    @staticmethod
    def vote( db: Session, user_id: int, recipe_id: int, value: bool) -> int:
        session = db()
        existing_vote = session.query(VoteEntity).filter(VoteEntity.user_id == user_id, VoteEntity.recipe_id == recipe_id).first()

        if existing_vote:
            existing_vote.value = value
        else:
            new_vote = VoteEntity(user_id=user_id, recipe_id=recipe_id, value=value)
            session.add(new_vote)

        session.commit()

        positive_votes = session.query(VoteEntity).filter(VoteEntity.recipe_id == recipe_id, VoteEntity.value == True).count()
        negative_votes = session.query(VoteEntity).filter(VoteEntity.recipe_id == recipe_id, VoteEntity.value == False).count()
        vote_count = positive_votes - negative_votes

        return vote_count
    
    