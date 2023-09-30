from typing import Optional

from sqlmodel import SQLModel, Field, Relationship


class Activity(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    user: Optional["User"] = Relationship(
        back_populates="activities"
    )
    kilocalories_count: int
    month_number: int
    year_number: int