from pydantic import BaseModel


class CheckTokenDTO(BaseModel):
    accessToken: str
