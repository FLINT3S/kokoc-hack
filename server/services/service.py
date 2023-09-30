from fastapi import FastAPI, APIRouter

from starlette.middleware.cors import CORSMiddleware

from data.database_service import DatabaseService

from controllers.auth_controller import auth_router


class APIService:
    def __init__(self, database: DatabaseService):
        self.debug = True
        self.app = FastAPI(title="API")
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

        self.app.include_router(router=api_router)
