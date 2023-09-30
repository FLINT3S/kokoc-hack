from data.database_service import DatabaseService
from data.model.user_status import UserStatusEnum

from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from services.user_service import UserService

from data.model.fund import Fund


class FundService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_fund(self, user_id: int, title: str):
        created_fund = Fund(user_id=user_id, title=title)

        return await self.database_service.save(created_fund)

    async def get_all_moderating_funds(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Fund)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Fund.user_id)
                if (user.user_status_id == UserStatusEnum.MODERATION.id):
                    listResult.append({
                        "id": row.Fund.id,
                        "title": row.Fund.title,
                        "requestedAt": user.date,
                    })
            return listResult

    async def get_all_approved_funds(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Fund)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Fund.user_id)
                if (user.user_status_id == UserStatusEnum.APPROVED.id):
                    listResult.append({
                        "id": row.Fund.id,
                        "title": row.Fund.title,
                        "requestedAt": user.date,
                    })
            return listResult

    async def get_all_canceled_funds(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Fund)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Fund.user_id)
                if (user.user_status_id == UserStatusEnum.CANCELED.id):
                    listResult.append({
                        "id": row.Fund.id,
                        "title": row.Fund.title,
                        "requestedAt": user.date,
                    })
            return listResult

    async def moderate(self, fund_id: int, status: bool):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Fund) \
                .where(Fund.id == fund_id) \
                .limit(1)

            fund = (await session.execute(st)).first()[0]

            user_service = UserService(database_service=self.database_service)
            user = await user_service.get_user_by_id(fund.user_id)

            if status:
                user.user_status_id = UserStatusEnum.APPROVED.id
            else:
                user.user_status_id = UserStatusEnum.CANCELED.id

            session.add(user)
            await session.commit()
            await session.refresh(user)

            return user

    async def get_fund_by_id(self, fund_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Fund) \
                .where(Fund.id == fund_id) \
                .limit(1)
            result = (await session.execute(st)).first()

            if result:
                return result[0]
