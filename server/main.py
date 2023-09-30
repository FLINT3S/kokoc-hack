import os

import uvicorn
from sqlmodel import SQLModel

import data.all_models
from data.database_service import DatabaseService
from services.role_service import RoleService

from services.service import APIService

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")

api = APIService(database_service)


@api.app.on_event("startup")
async def init_db():
    async with database_service.engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)
        role_service = RoleService(database_service)
        await role_service.drop_and_init_default_data()


@api.app.get("/api/status")
async def root():
    return {"status": "OK"}


if __name__ == "__main__":
    uvicorn.run("main:api.app", port=5000, reload=True, workers=1)
