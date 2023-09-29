import uvicorn

from services.service import APIService

api = APIService()


@api.app.get("/api/status")
async def root():
    return {"status": "OK"}


if __name__ == "__main__":
    uvicorn.run("main:api.app", port=5000, reload=True, workers=1)
