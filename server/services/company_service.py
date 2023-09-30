from data.database_service import DatabaseService
from data.model.company import Company


class CompanyService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_company(self, user_id: int, title: str):
        created_company = Company(user_id=user_id, title=title)

        return await self.database_service.save(created_company)
