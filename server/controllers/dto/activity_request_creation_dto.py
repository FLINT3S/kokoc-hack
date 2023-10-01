from pydantic import BaseModel


class ActivityRequestCreationDTO(BaseModel):
    employee_id: int
    images: str
    training_information: str
    adding_kilocalories_count: int
