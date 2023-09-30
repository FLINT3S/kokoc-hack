from enum import Enum
from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship


class Role(SQLModel, table=True):
    __tablename__ = "role"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(default=None, nullable=False)
    users: List["User"] = Relationship(back_populates="role")


class RoleEnum(Enum):
    def __new__(cls, *args, **kwds):
        obj = object.__new__(cls)
        obj._value_ = args[0]
        return obj

    def __init__(self, _: str, id: int = 0):
        self.id = id

    def __str__(self):
        return self.value

    SUPERADMIN = 1
    USER = 2
    COMPANYADMIN = 3
    FUNDADMIN = 4


if __name__ == "__main__":
    print(len(RoleEnum))
