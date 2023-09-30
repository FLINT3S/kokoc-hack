import os

from fastapi import APIRouter, HTTPException

from controllers.dto.check_token_dto import CheckTokenDTO
from controllers.dto.login_data_dto import LoginDataDTO
from controllers.dto.company_reg_dto import CompanyRegDTO
from controllers.dto.employee_reg_dto import EmployeeRegDTO

from data.database_service import DatabaseService
from services.jwt_service import JWTService
from services.user_service import UserService
from services.company_service import CompanyService
from services.employee_service import EmployeeService

from data.model.role import RoleEnum


auth_router = APIRouter()
database_service = DatabaseService(
    f"postgresql+asyncpg://{os.environ['POSTGRES_USER']}:{os.environ['POSTGRES_PASSWORD']}@81.200.149.171:5432/{os.environ['POSTGRES_DB']}")
user_service = UserService(database_service=database_service)
company_service = CompanyService(database_service)
employee_service = EmployeeService(database_service)

jwt_service = JWTService()


@auth_router.post("/login")
async def login(login_data: LoginDataDTO):
    if await user_service.check_user_password(login_data.login, login_data.password):
        user = await user_service.get_user_by_login(login_data.login)
        # TODO
        return {
            "accessToken": jwt_service.generate_jwt(user.id),
            "user": user
        }
    raise HTTPException(401, "Неверный логин или пароль")


@auth_router.post("/company-registration")
async def company_registration(company_reg_dto: CompanyRegDTO):
    user = await user_service.create_user(login=company_reg_dto.login, plain_password=company_reg_dto.password,
                                          role_id=RoleEnum.COMPANYADMIN.id)
    company = await company_service.create_company(user_id=user.id, title=company_reg_dto.title)

    return {
        "accessToken": jwt_service.generate_jwt(user.id),
        "user": user,
        "company": company
    }

@auth_router.post("/user-registration")
async def user_registration(employee_reg_dto: EmployeeRegDTO):
    user = await user_service.create_user(login=employee_reg_dto.login, plain_password=employee_reg_dto.password,
                                          role_id=RoleEnum.USER.id)
    employee = await employee_service.create_employee(user_id=user.id, name=employee_reg_dto.name, surname=employee_reg_dto.surname,
                                                      division_id=employee_reg_dto.divisionId)

    return {
        "accessToken": jwt_service.generate_jwt(user.id),
        "user": user,
        "employee": employee
    }

@auth_router.post("/check")
async def check(token_data: CheckTokenDTO):
    decoded = jwt_service.check_jwt(token_data.accessToken)

    if not decoded or not decoded.get("user_id"):
        raise HTTPException(403, "Ошибка проверки токена")

    return await user_service.get_user_by_id(int(decoded.get("user_id")))
