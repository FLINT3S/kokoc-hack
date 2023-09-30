import datetime

import bcrypt
from fastapi import HTTPException

from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from data.database_service import DatabaseService

from data.model.division import Division


class DivisionService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def get_division_by_id(self, division_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Division) \
                .where(Division.id == division_id) \
                .limit(1)
            result = (await session.execute(st)).first()

            if result:
                return result[0]