from sqlalchemy.orm import Session, Query

from validators.pagination_validator import PaginationValidator


def paginate(session:  Query[any], paginationValidator: PaginationValidator):
    if not paginationValidator:
        return session
    return session.offset(paginationValidator.page * paginationValidator.size).limit(paginationValidator.size)