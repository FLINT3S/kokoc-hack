from typing import Any, List, Optional, Sequence, Type

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from sqlmodel import SQLModel

from services.roleservice import RoleService


class DatabaseService:
    def __init__(self, dsn: str):
        self.engine = create_async_engine(url=dsn, future=True)
        self.session: Optional[AsyncSession] = None
        self.session = sessionmaker(self.engine, class_=AsyncSession, expire_on_commit=False)()

    async def start(self):
        async with self.engine.begin() as connection:
            await connection.run_sync(SQLModel.metadata.create_all)

        self.session = sessionmaker(self.engine, class_=AsyncSession, expire_on_commit=False)()

    async def stop(self):
        await self.session.close()
        self.session = None

    async def _first(self, query) -> Optional[Any]:
        result = (await self.session.execute(query)).first()
        if result:
            return result[0]

    async def _all(self, query, unpack: bool = False) -> Sequence[Any]:
        results = (await self.session.execute(query)).all() or []
        if unpack:
            results = [result[0] for result in results]
        return results

    async def save(self, instance: SQLModel) -> SQLModel:
        self.session.add(instance)
        await self.session.commit()
        await self.session.refresh(instance)

        return instance

    async def init_meta_data(self):
        SQLModel.metadata.create_all(self.engine)

    async def reset(self):
        await SQLModel.metadata.clear()
        await self.init_meta_data()
        role_service = RoleService(self)
        role_service.drop_and_init_default_data()
