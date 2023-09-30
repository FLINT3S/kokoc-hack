from enum import Enum
from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship


class Role(SQLModel, table=True):
    __tablename__ = "role"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(default=None, nullable=False)
    users: List["User"] = Relationship(back_populates="role")


class RoleEnum(Enum):
    SUPERADMIN = "superadmin", 1,
    USER = "user", 2,
    COMPANYADMIN = "companyadmin", 3,
    FUNDADMIN = "fundadmin", 4,
    def __new__(cls, *args, **kwds):
        obj = object.__new__(cls)
        obj._value_ = args[0]
        return obj

    def __init__(self, _: str, id : int = 0):
        self.id = id

    def __str__(self):
        return self.value

    @classmethod
    def list(cls):
        return list(map(lambda c: c, cls))
