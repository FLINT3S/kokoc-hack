from datetime import datetime
from typing import Optional

from sqlmodel import SQLModel, Field, Relationship

class ActivityRequest(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    employee_id: int = Field(foreign_key="employee.id")
    employee: Optional["Employee"] = Relationship(
        back_populates="activities"
    )
    training_information: str = Field(default=None, nullable=False)
    adding_kilocalories_count: int = Field(default=None, nullable=False)
    date: datetime = Field(default=None, nullable=False)
    image_path: str = Field(default=None, nullable=False)