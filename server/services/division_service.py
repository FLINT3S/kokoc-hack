from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from data.database_service import DatabaseService

from data.model.division import Division

from services.company_service import CompanyService


class DivisionService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_division(self, title: str, company_id: int):
        created_division = Division(title=title, company_id=company_id)

        return await self.database_service.save(created_division)

    async def get_divisions_by_company_id(self, company_id: int):
        company_service = CompanyService(database_service=self.database_service)
        company = await company_service.get_company_by_id(company_id)
        result = list()
        for division in company.divisions:
            result.append(division)

        return result


    async def get_division_by_id(self, division_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Division) \
                .where(Division.id == division_id) \
                .limit(1)
            result = (await session.execute(st)).first()

            if result:
                return result[0]
