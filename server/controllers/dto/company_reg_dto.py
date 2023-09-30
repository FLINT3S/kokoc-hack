from pydantic import BaseModel

class CompanyRegDTO(BaseModel):
    title: str
    login: str
    password: str
    passwordReenter: str
