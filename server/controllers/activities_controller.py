import os
from typing import Annotated

from fastapi import APIRouter, UploadFile, File, Form

from data.database_service import DatabaseService
from services.activity_service import ActivityService

from controllers.dto.activity_request_creation_dto import ActivityRequestCreationDTO

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
activity_service = ActivityService(database_service)

activities_route = APIRouter()


@activities_route.post("/create-activity-request")
async def get_all_moderation(employee_id: str = Form(...), training_information: str = Form(...),
                             adding_kilocalories_count: str = Form(...),
                             file: UploadFile = File(...)):
    return await activity_service.create_activity_request(employee_id=employee_id,
                                                          training_information=training_information,
                                                          adding_kilocalories_count=adding_kilocalories_count,
                                                          file=file)
