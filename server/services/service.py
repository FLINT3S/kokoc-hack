from fastapi import FastAPI, APIRouter

from starlette.middleware.cors import CORSMiddleware


class APIService:
    def __init__(self):
        self.debug = True
        self.app = FastAPI(title="API")

        origins = ["*"]
        self.app.add_middleware(
            CORSMiddleware,
            allow_origins=origins,
            allow_credentials=True,
            allow_methods=[""],
            allow_headers=[""],
        )

        self.attach_routes()

    def attach_routes(self):
        api_router = APIRouter()
        api_router.prefix = "/api"

        self.app.include_router(router=api_router)
