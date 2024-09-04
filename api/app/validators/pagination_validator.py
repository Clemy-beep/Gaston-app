from pydantic import BaseModel, Field

class PaginationValidator(BaseModel): 
    page: int = Field(ge=0, default=0) 
    size: int = Field(ge=1, le=100, default=10)