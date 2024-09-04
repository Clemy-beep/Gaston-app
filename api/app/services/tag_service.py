from sqlalchemy.orm import Session

from validators.tag_validator import (
    TagAddValidator,
    TagSearchValidator,
    TagUpdateValidator,
)
from entities.tags import TagEntity

from entities.users import UserEntity

from ._singleton import Singleton


class TagService(metaclass=Singleton):
    def _by_name(self, session: Session, name: list[str]):
        # get tag of each name
        return session.query(TagEntity).filter(TagEntity.name.in_(name))

    def _by_ids(self, session: Session, ids: list[int]):
        return session.query(TagEntity).filter(TagEntity.id.in_(ids))

   def search_tags(self, session: Session, tags: TagSearchValidator):
       #patch pas opti mais fonctionne
        tmp1 = []
        tmp2 = []
        if  tags.ids:
            tmp2 = session.query(TagEntity).filter(TagEntity.id.in_(tags.ids)).all()

        if  tags.names:
            tmp1 = session.query(TagEntity).filter(TagEntity.name.in_(tags.names)).all()

        resulting_list = list(tmp1)
        resulting_list.extend(x for x in tmp2 if x not in resulting_list)

        return resulting_list

    def get_tag_by_id(self, session: Session, tag_id: int):
        return session.query(TagEntity).filter(TagEntity.id == tag_id).first()
    
    def get_all_tags(self, session: Session):
        return session.query(TagEntity).all()

    def create_tag(self, session: Session, tag: TagAddValidator):
        db_tag = TagEntity(**tag.model_dump(exclude_none=True, exclude_unset=True))
        session.add(db_tag)
        session.commit()
        session.refresh(db_tag)
        return db_tag

    def delete_tag(self, session: Session, tag_id: int):
        tag = session.query(TagEntity).filter(TagEntity.id == tag_id)
        session.delete(tag)
        session.commit()
        return True

    def update_tag(self, session: Session, tag: TagUpdateValidator):
        db_tag = tag.model_dump(exclude_none=True, exclude_unset=True, exclude="id")
        session.query(TagEntity).filter(TagEntity.id == tag.id).update(db_tag)
        session.commit()
        return db_tag
