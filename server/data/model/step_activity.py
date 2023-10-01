from typing import Optional

from sqlmodel import SQLModel, Field, Relationship


class StepActivity(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    employee_id: int = Field(foreign_key="employee.id")
    employee: Optional["Employee"] = Relationship(
        back_populates="step_activities"
    )
    count: int = Field(default=0, nullable=False)
    day: int = Field(default=None, nullable=False)
    month: int = Field(default=None, nullable=False)
    year: int = Field(default=None, nullable=False)
