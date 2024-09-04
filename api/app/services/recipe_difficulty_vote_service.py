from ._singleton import Singleton
from dependencies.database import Session
from validators.recipe_difficulty_vote_validator import RecipeDifficultyVoteCreate, RecipeDifficultyVoteUpdate
from entities.recipe_difficulty_votes import RecipeDifficultyVoteEntity


class RecipeDifficultyVoteService(metaclass=Singleton):
    def __init__(self):
        pass

    def get_recipe_difficulty_vote_by_id(self, session: Session, recipe_difficulty_vote_id: int):
        db_recipe_difficulty_vote= session.query(RecipeDifficultyVoteEntity).filter(RecipeDifficultyVoteEntity.id == recipe_difficulty_vote_id).first()
        return db_recipe_difficulty_vote

    def create_recipe_difficulty_vote(self, session: Session, recipe_difficulty_vote_data: RecipeDifficultyVoteCreate):
        db_recipe_difficulty_vote= RecipeDifficultyVoteEntity(**recipe_difficulty_vote_data.model_dump(exclude_none=True, 
                                                            exclude_unset=True,
                                                            exclude={'reporting'}))
        session.add(db_recipe_difficulty_vote)
        session.commit()
        session.refresh(db_recipe_difficulty_vote)
        return db_recipe_difficulty_vote

    def update_recipe_difficulty_vote(self, recipe_difficulty_vote_id: int, session: Session, recipe_difficulty_vote_data: RecipeDifficultyVoteUpdate):
        db_recipe_difficulty_vote= session.query(RecipeDifficultyVoteEntity).filter(RecipeDifficultyVoteEntity.id == recipe_difficulty_vote_id).first()
        if db_recipe_difficulty_vote:
            db_recipe_difficulty_vote.difficulty = recipe_difficulty_vote_data.model_dump(include={'difficulty'})['difficulty']
            session.commit()
            session.refresh(db_recipe_difficulty_vote)
            return db_recipe_difficulty_vote
        return None 

    def delete_recipe_difficulty_vote_by_id(self, session: Session, recipe_difficulty_vote_id: int):
        db_recipe_difficulty_vote= session.query(RecipeDifficultyVoteEntity).filter(RecipeDifficultyVoteEntity.id == recipe_difficulty_vote_id).first()
        if db_recipe_difficulty_vote:
            session.delete(db_recipe_difficulty_vote)
            session.commit()
            return True
        return False 
    
    def get_recipe_difficulty_votes_by_recipe_id(self, session: Session, id_recipe: int):
        recipe_difficulty_votes = session.query(RecipeDifficultyVoteEntity).filter(RecipeDifficultyVoteEntity.id_recipe == id_recipe).all()
        return recipe_difficulty_votes    

    def calculate_average_recipe_difficulty(self, session: Session, id_recipe: int):
        recipe_difficulty_votes = self.get_recipe_difficulty_votes_by_recipe_id(session, id_recipe)
        if not recipe_difficulty_votes:
            return 0  # Retourne 0 si aucune note n'est trouvée pour éviter la division par zéro
        total_difficulty = sum(vote.difficulty for vote in recipe_difficulty_votes)
        average_difficulty = round(total_difficulty / len(recipe_difficulty_votes), 1)
        return average_difficulty                                                 