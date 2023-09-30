from typing import Optional

from sqlmodel import SQLModel, Field

class Fund(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    name: str = Field(default=None, nullable=False)
