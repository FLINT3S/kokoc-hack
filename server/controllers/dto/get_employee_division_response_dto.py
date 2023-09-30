import datetime
from typing import Optional

from pydantic import BaseModel

from data.model.division import Division


class GetEmployeeDivisionResponseDTO(BaseModel):
    id: int
    name: str
    surname: str
    division: Optional[Division]
    requestedAt: datetime.datetime
