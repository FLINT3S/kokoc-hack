import os

from fastapi import APIRouter, UploadFile, File, Form

from data.database_service import DatabaseService
from services.activity_service import ActivityService

from controllers.dto.activity_request_moderate_dto import ActivityRequestModerateDTO

from controllers.dto.activity_request_creation_dto import ActivityRequestCreationDTO

database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
activity_service = ActivityService(database_service)

activities_route = APIRouter()


@activities_route.post("/create-activity-request")
async def get_all_moderation(activity_request_creation_dto: ActivityRequestCreationDTO):
    return await activity_service.create_activity_request(employee_id=activity_request_creation_dto.employee_id,
                                                          training_information=activity_request_creation_dto.training_information,
                                                          adding_kilocalories_count=activity_request_creation_dto.adding_kilocalories_count,
                                                          images=activity_request_creation_dto.images)


@activities_route.post("/save_training_image")
async def get_all_moderation(file: UploadFile = File(...)):
    return await activity_service.save_training_imamge(file)


@activities_route.get("/get-all-in-company/{company_id}")
async def get_all_moderation(company_id: int):
    return await activity_service.get_all_activity_requests_in_company(company_id)


@activities_route.get("/get_activity_request_by_id/{activity_request_id}")
async def get_all_moderation(activity_request_id: int):
    return await activity_service.get_activity_request_by_id(activity_request_id)


@activities_route.get("/get_activity_request_image_by_id/{activity_request_id}")
async def get_all_moderation(activity_request_id: int):
    return await activity_service.get_image_from_activity_request(activity_request_id)


@activities_route.post("/moderate")
async def moderate(activity_request_moderate_dto: ActivityRequestModerateDTO):
    return await activity_service.moderate_activity_request(activity_request_moderate_dto.activity_request_id,
                                                            activity_request_moderate_dto.status)
