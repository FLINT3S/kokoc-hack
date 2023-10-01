from pydantic import BaseModel


class ActivityByDateAndEmployeeDTO(BaseModel):
    employee_id: int
    month: int
    year: int
