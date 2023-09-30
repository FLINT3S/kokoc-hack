from data.database_service import DatabaseService

from data.model.fund import Fund


class FundService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_fund(self, user_id: int, title: str):
        created_fund = Fund(user_id=user_id, title=title)

        return await self.database_service.save(created_fund)