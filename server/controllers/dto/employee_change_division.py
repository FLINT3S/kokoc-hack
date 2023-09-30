from pydantic import BaseModel

class EmployeeChangeDivisionDTO(BaseModel):
    employee_id: int
    division_id: int