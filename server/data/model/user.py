from datetime import datetime
from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship

from data.model.role import Role
from data.model.user_status import UserStatus


class User(SQLModel, table=True):
    __tablename__ = "user"

    id: Optional[int] = Field(default=None, primary_key=True)
    login: str = Field(default=None, nullable=False, unique=True)
    password: str = Field(default=None, nullable=False)

    role_id: int = Field(foreign_key="role.id")
    role: Optional["Role"] = Relationship(
        back_populates="users"
    )

    user_status_id: int = Field(foreign_key="user_status.id")
    user_status: Optional["UserStatus"] = Relationship(
        back_populates="users"
    )

    date: datetime = Field(default=None, nullable=False)