from pydantic import BaseModel

class FundModerateDTO(BaseModel):
    fund_id: int
    status: bool