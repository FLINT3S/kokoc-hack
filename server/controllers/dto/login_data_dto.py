from pydantic import BaseModel

class LoginDataDTO(BaseModel):
    login: str
    password: str