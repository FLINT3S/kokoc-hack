from pydantic import BaseModel

class EmployeeModerateDTO(BaseModel):
    employee_id: int
    status: bool