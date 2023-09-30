from pydantic import BaseModel

class FundRegDTO(BaseModel):
    title: str
    login: str
    password: str
    passwordReenter: str
