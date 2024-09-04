from pydantic import BaseModel
 

class ErrorValidator(BaseModel):
    message: str
    code: int | None 
    # error: str | None # activate if needed
    field: str | None # parameter containing the error

class ErrorsValidator(BaseModel):
    errors: list[ErrorValidator] | None