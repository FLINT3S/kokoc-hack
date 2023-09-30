import os

from controllers.dto.division_dto import DivisionDTO
from fastapi import APIRouter

from data.database_service import DatabaseService
from services.division_service import DivisionService

division_router = APIRouter()
database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
division_service = DivisionService(database_service)


@division_router.post("/create")
async def create_division(division_dto: DivisionDTO):
    division = await division_service.create_division(title=division_dto.title, company_id=division_dto.company_id)

    return {}


@division_router.get("/get-all/{company_id}")
async def get_divisions(company_id: int):
    return await division_service.get_divisions_by_company_id(company_id=company_id)
