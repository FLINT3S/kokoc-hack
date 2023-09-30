from typing import Optional

from sqlmodel import SQLModel, Field, Relationship

from data.model.division import Division

class Employee(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    name: str = Field(default=None, nullable=False)
    surname: str = Field(default=None, nullable=False)
    division_id: int = Field(foreign_key="division.id")
    division: Optional["Division"] = Relationship(
        back_populates="employees"
    )