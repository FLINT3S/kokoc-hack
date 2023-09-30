from data.database_service import DatabaseService
from data.model.employee import Employee


class EmployeeService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_employee(self, user_id: int, name: str, surname: str, company_id: int, division_id: int):
        created_employee = Employee(user_id=user_id, name=name, surname=surname, company_id=company_id, division_id=division_id)

        return await self.database_service.save(created_employee)