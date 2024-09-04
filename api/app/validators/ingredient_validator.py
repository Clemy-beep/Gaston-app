from pydantic import BaseModel


class ingredientAddValidator(BaseModel): 
    name: str
    quantity: str # ex: 1.2 kg, 1 L, 1 unit, 1/2 cup    

