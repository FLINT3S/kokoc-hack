from pydantic import BaseModel


class ActivityRequestCreationDTO(BaseModel):
    employee_id: int
    training_information: str
    adding_kilocalories_count: int
