from datetime import datetime
from typing import Optional

from sqlmodel import SQLModel, Field

class ActivityRequest(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    user: Optional["User"] = Relationship(
        back_populates="activities"
    )
    adding_kilocalories_count: int
    date: datetime = Field(default=None, nullable=False)
    # TODO фотография