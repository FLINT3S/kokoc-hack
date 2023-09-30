from pydantic import BaseModel

class EmployeeRegDTO(BaseModel):
    name: str
    surname: str
    login: str
    password: str
    passwordReenter: str
    companyId: int
    divisionId: int
