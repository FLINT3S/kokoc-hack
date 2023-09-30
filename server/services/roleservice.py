from sqlalchemy import select
from sqlmodel.ext.asyncio.session import AsyncSession

from data.model.role import Role
from data.model.role import RoleEnum

from data.databaseservice import DatabaseService


class RoleService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def drop_and_init_default_data(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Role)
            results = (await session.execute(st))
            for value in results:
                await session.delete(value[0])
                await session.commit()
            for role in RoleEnum.list():
                await self.database_service.save(Role(id=role.id, name=role.value))
                await session.commit()
