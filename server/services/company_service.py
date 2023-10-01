from sqlalchemy.orm import selectinload

from data.database_service import DatabaseService
from data.model.company import Company
from data.model.division import Division
from data.model.user_status import UserStatusEnum

from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from services.user_service import UserService

from data.model.user import User


class CompanyService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_company(self, user_id: int, title: str):
        created_company = Company(user_id=user_id, title=title)
        await self.database_service.save(created_company)
        division = Division(title='Общее', company_id=created_company.id)
        created_company.divisions.append(division)
        return await self.database_service.save(created_company)



    async def get_all_moderating_companies(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Company)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Company.user_id)
                if (user.user_status_id == UserStatusEnum.MODERATION.id):
                    employeesCount = 0
                    for division in row.Company.divisions:
                        employeesCount += len(division.employees)
                    listResult.append({
                        "id": row.Company.id,
                        "title": row.Company.title,
                        "requestedAt": user.date,
                        "employeesNumber": employeesCount
                    })
            return listResult

    async def get_all_approved_companies(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Company)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Company.user_id)
                if (user.user_status_id == UserStatusEnum.APPROVED.id):
                    employeesCount = 0
                    for division in row.Company.divisions:
                        employeesCount += len(division.employees)
                    listResult.append({
                        "id": row.Company.id,
                        "title": row.Company.title,
                        "requestedAt": user.date,
                        "employeesNumber": employeesCount
                    })
            return listResult

    async def get_all_canceled_companies(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Company)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Company.user_id)
                if (user.user_status_id == UserStatusEnum.CANCELED.id):
                    employeesCount = 0
                    for division in row.Company.divisions:
                        employeesCount += len(division.employees)
                    listResult.append({
                        "id": row.Company.id,
                        "title": row.Company.title,
                        "requestedAt": user.date,
                        "employeesNumber": employeesCount
                    })
            return listResult

    async def moderate(self, company_id: int, status: bool):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Company) \
                .where(Company.id == company_id) \
                .limit(1)

            company = (await session.execute(st)).first()[0]

            user_service = UserService(database_service=self.database_service)
            user = await user_service.get_user_by_id(company.user_id)

            if status:
                user.user_status_id = UserStatusEnum.APPROVED.id
            else:
                user.user_status_id = UserStatusEnum.CANCELED.id

            session.add(user)
            await session.commit()
            await session.refresh(user)

            return user


    async def get_company_by_id(self, company_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Company).options(selectinload(Company.divisions)) \
                .where(Company.id == company_id) \
                .limit(1)
            result = (await session.execute(st)).first()

            if result:
                return result[0]
