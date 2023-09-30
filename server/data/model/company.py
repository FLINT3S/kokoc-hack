from typing import Optional

from sqlmodel import SQLModel, Field, Relationship

from data.model.employee import Employee
from data.model.division import Division

class Company(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    name: str = Field(default=None, nullable=False)
    employees: List["Employee"] = Relationship(back_populates="company")
    divisions: List["Division"] = Relationship(back_populates="company")