import os

from fastapi import APIRouter

from data.database_service import DatabaseService
from services.fund_service import FundService

from controllers.dto.fund_moderate_dto import FundModerateDTO

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
funds_service = FundService(database_service)

funds_router = APIRouter()


@funds_router.get("/get-all-moderation")
async def get_all_moderation():
    return await funds_service.get_all_moderating_funds()


@funds_router.get("/get-all-approved")
async def get_all_approved():
    return await funds_service.get_all_approved_funds()


@funds_router.get("/get-all-canceled")
async def get_all_canceled():
    return await funds_service.get_all_canceled_funds()


@funds_router.post("/moderate")
async def moderate(fund_moderate_dto: FundModerateDTO):
    return await funds_service.moderate(fund_moderate_dto.company_id, fund_moderate_dto.status)
