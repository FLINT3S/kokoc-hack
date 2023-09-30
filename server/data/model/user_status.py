from datetime import datetime
from enum import Enum
from typing import Optional, List

from sqlmodel import SQLModel, Field, Relationship


class UserStatus(SQLModel, table=True):
    __tablename__ = "user_status"

    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    users: List["User"] = Relationship(back_populates="user_status")

class UserStatusEnum(Enum):
    MODERATION = "На модерации", 1,
    APPROVED = "Принято", 2,
    CANCELED = "Отклонено", 3,

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