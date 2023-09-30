from pydantic import BaseModel

class CompanyModerateDTO(BaseModel):
    company_id: int
    status: bool