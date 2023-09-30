import os
from typing import List

from fastapi import APIRouter

from controllers.dto.get_employee_division_response_dto import GetEmployeeDivisionResponseDTO
from data.database_service import DatabaseService
from data.model.employee import Employee

from services.employee_service import EmployeeService

from controllers.dto.employee_moderate_dto import EmployeeModerateDTO

from controllers.dto.employee_change_division import EmployeeChangeDivisionDTO

employees_router = APIRouter()
database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
employee_service = EmployeeService(database_service)


@employees_router.get("/get-all")
async def get_all_employees():
    return await employee_service.get_all_employees()


@employees_router.get("/get-all-moderation")
async def get_all_moderation():
    return await employee_service.get_all_moderating_employees()


@employees_router.get("/get-all-approved", response_model=List[GetEmployeeDivisionResponseDTO])
async def get_all_approved():
    return await employee_service.get_all_approved_employees()


@employees_router.get("/get-all-canceled")
async def get_all_canceled():
    return await employee_service.get_all_canceled_employees()


@employees_router.post("/moderate")
async def moderate(employee_moderate_dto: EmployeeModerateDTO):
    return await employee_service.moderate(employee_moderate_dto.employee_id, employee_moderate_dto.status)


@employees_router.post("/change-division")
async def moderate(employee_change_division_dto: EmployeeChangeDivisionDTO):
    return await employee_service.change_division(employee_change_division_dto.employee_id,
                                                  employee_change_division_dto.division_id)
