from pydantic import BaseModel


class ChangeEmployeeAnonymousDTO(BaseModel):
    employee_id: int
    anonymous: bool
