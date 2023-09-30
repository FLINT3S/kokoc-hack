from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship

class Company(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    title: str = Field(default=None, nullable=False)
    divisions: List["Division"] = Relationship(back_populates="company")
