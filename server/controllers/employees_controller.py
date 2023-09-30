import os

from fastapi import APIRouter

from data.database_service import DatabaseService

from services.employee_service import EmployeeService

employees_router = APIRouter()
database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
employee_service = EmployeeService(database_service)


@employees_router.get("/get-all")
async def get_all_employees():
    return await employee_service.get_all_employees()
