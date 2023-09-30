from pydantic import BaseModel

class DivisionDTO(BaseModel):
    title: str
    company_id: int