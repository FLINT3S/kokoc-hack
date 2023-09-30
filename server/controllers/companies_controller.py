import os

from fastapi import APIRouter

from data.database_service import DatabaseService
from services.company_service import CompanyService

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
company_service = CompanyService(database_service)

companies_router = APIRouter()

@companies_router.get("/get-all-moderaion")
async def get_all():
    return await company_service.get_all_moderating_companies()

@companies_router.get("/get-all-approved")
async def get_all():
    return await company_service.get_all_approved_companies()

@companies_router.get("/get-all-canceled")
async def get_all():
    return await company_service.get_all_canceled_companies()
