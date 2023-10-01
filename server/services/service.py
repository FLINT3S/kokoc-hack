from fastapi import FastAPI, APIRouter

from starlette.middleware.cors import CORSMiddleware

from data.database_service import DatabaseService

from controllers.auth_controller import auth_router
from controllers.companies_controller import companies_router
from controllers.funds_controller import funds_router
from controllers.divisions_controller import division_router

from controllers.employees_controller import employees_router

from controllers.activities_controller import activities_route
from fastapi.staticfiles import StaticFiles


class APIService:
    def __init__(self, database: DatabaseService):
        self.debug = True
        self.app = FastAPI(title="API")
        self.app.mount("/static", StaticFiles(directory="./code/public/"), name="static")
        self.database = database

        origins = ["*"]
        self.app.add_middleware(
            CORSMiddleware,
            allow_origins=origins,
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )
        self.app.state.database = database

        self.attach_routes()

    def attach_routes(self):
        api_router = APIRouter()
        api_router.prefix = "/api"
        self.app.include_router(router=auth_router, prefix="/api/auth")
        self.app.include_router(router=companies_router, prefix="/api/companies")
        self.app.include_router(router=funds_router, prefix="/api/funds")
        self.app.include_router(router=division_router, prefix="/api/divisions")
        self.app.include_router(router=employees_router, prefix="/api/employees")
        self.app.include_router(router=activities_route, prefix="/api/activities")

        self.app.include_router(router=api_router)
