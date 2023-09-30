import os

from fastapi import APIRouter

from data.database_service import DatabaseService
from services.company_service import CompanyService

from controllers.dto.company_moderate_dto import CompanyModerateDTO

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
company_service = CompanyService(database_service)

companies_router = APIRouter()

@companies_router.get("/get-all-moderation")
async def get_all_moderation():
    return await company_service.get_all_moderating_companies()

@companies_router.get("/get-all-approved")
async def get_all_approved():
    return await company_service.get_all_approved_companies()

@companies_router.get("/get-all-canceled")
async def get_all_canceled():
    return await company_service.get_all_canceled_companies()

@companies_router.post("/moderate")
async def moderate(company_moderate_dto: CompanyModerateDTO):
    return await company_service.moderate(company_moderate_dto.company_id, company_moderate_dto.status)
