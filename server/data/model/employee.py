from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship

from data.model.division import Division
from data.model.activity import Activity
from data.model.activity_request import ActivityRequest


class Employee(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    name: str = Field(default=None, nullable=False)
    surname: str = Field(default=None, nullable=False)
    division_id: int = Field(foreign_key="division.id")
    division: Optional["Division"] = Relationship(
        back_populates="employees"
    )

    activities: List["Activity"] = Relationship(back_populates="employee", sa_relationship_kwargs={'lazy': 'selectin'})
    activities_requests: List["ActivityRequest"] = Relationship(back_populates="employee", sa_relationship_kwargs={'lazy': 'selectin'})
