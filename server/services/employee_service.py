from data.database_service import DatabaseService
from data.model.employee import Employee
from sqlmodel import select

from sqlmodel.ext.asyncio.session import AsyncSession

from services.user_service import UserService

from data.model.user_status import UserStatusEnum


class EmployeeService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_employee(self, user_id: int, name: str, surname: str, division_id: int):
        created_employee = Employee(user_id=user_id, name=name, surname=surname, division_id=division_id)

        return await self.database_service.save(created_employee)

    async def get_all_employees(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee)
            results = (await session.execute(st))

            return [dict(row.Employee) for row in results]

    async def get_all_moderating_employees(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Employee.user_id)
                if (user.user_status_id == UserStatusEnum.MODERATION.id):
                    listResult.append(row.Employee)
            return listResult

    async def get_all_approved_employees(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Employee.user_id)
                if (user.user_status_id == UserStatusEnum.APPROVED.id):
                    listResult.append(row.Employee)
            return listResult

    async def get_all_canceled_employees(self):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee)
            result = (await session.execute(st)).all()

            user_service = UserService(database_service=self.database_service)
            listResult = list()

            for row in result:
                user = await user_service.get_user_by_id(row.Employee.user_id)
                if (user.user_status_id == UserStatusEnum.CANCELED.id):
                    listResult.append(row.Employee)
            return listResult

    async def moderate(self, employee_id: int, status: bool):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee) \
                .where(Employee.id == employee_id) \
                .limit(1)

            employee = (await session.execute(st)).first()[0]

            user_service = UserService(database_service=self.database_service)
            user = await user_service.get_user_by_id(employee.user_id)

            if status:
                user.user_status_id = UserStatusEnum.APPROVED.id
            else:
                user.user_status_id = UserStatusEnum.CANCELED.id

            session.add(user)
            await session.commit()
            await session.refresh(user)

            return user

    async def change_division(self, employee_id: int, division_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(Employee) \
                .where(Employee.id == employee_id) \
                .limit(1)

            employee = (await session.execute(st)).first()[0]
            employee.division_id = division_id

            session.add(employee)
            await session.commit()
            await session.refresh(employee)

            return employee
