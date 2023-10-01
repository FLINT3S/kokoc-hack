from pydantic import BaseModel


class AddingCountStepsDTO(BaseModel):
    employee_id: int
    count: int
    human_weight: int
