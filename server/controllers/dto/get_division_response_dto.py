from typing import List

from pydantic import BaseModel

from data.model.employee import Employee


class GetDivisionResponseDto(BaseModel):
    id: int
    company_id: int
    title: str
    employees: List[Employee]