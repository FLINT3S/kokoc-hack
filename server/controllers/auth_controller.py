import os

from fastapi import APIRouter, HTTPException

from controllers.dto.check_token_dto import CheckTokenDTO
from controllers.dto.login_data_dto import LoginDataDTO
from data.database_service import DatabaseService
from services.jwt_service import JWTService
from services.user_service import UserService

auth_router = APIRouter()
user_service = UserService(database_service=DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}"))

jwt_service = JWTService()


@auth_router.post("/login")
async def login(login_data: LoginDataDTO):
    if await user_service.check_user_password(login_data.login, login_data.password):
        user = await user_service.get_user_by_login(login_data.login)
        return {
            "accessToken": jwt_service.generate_jwt(user.id),
            "user": user
        }
    raise HTTPException(401, "Неверный логин или пароль")


@auth_router.post("/check")
async def check(token_data: CheckTokenDTO):
    decoded = jwt_service.check_jwt(token_data.accessToken)

    if not decoded or not decoded.get("user_id"):
        raise HTTPException(403, "Ошибка проверки токена")

    return await user_service.get_user_by_id(int(decoded.get("user_id")))
