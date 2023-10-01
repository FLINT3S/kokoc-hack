import datetime
import os
import uuid

import aiofiles
from aiohttp.web_fileresponse import FileResponse
from data.database_service import DatabaseService

from data.model.activity_request import ActivityRequest
from fastapi import HTTPException

from services.employee_service import EmployeeService
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession
from PIL import Image

PATH = os.path.join(os.getcwd())


class ActivityService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_activity_request(self, employee_id: int, training_information: str,
                                      adding_kilocalories_count: int, file):
        filename = "/code/public/" + f'{uuid.uuid4().hex}' + '.jpg'
        try:
            im = Image.open(file.file)
            if im.mode in ("RGBA", "P"):
                im = im.convert("RGB")
            im.save(filename, 'JPEG', quality=50)
        except Exception:
            raise HTTPException(status_code=500, detail='Что-то пошло не так')
        finally:
            file.file.close()
            im.close()

        activity_request = ActivityRequest(employee_id=employee_id, training_information=training_information,
                                           adding_kilocalories_count=adding_kilocalories_count,
                                           date=datetime.datetime.now(), image_path=file_name)

        return await self.database_service.save(activity_request)

    async def get_all_activity_requests_in_company(self, company_id: int):
        employee_service = EmployeeService(self.database_service)
        activity_requests = list()

        employees = await employee_service.get_employees_in_company(company_id)
        for employee in employees:
            for activity_request in employee.activities_requests:
                activity_requests.append(activity_request)

        return activity_requests

    async def get_activity_request_by_id(self, activity_request_id: int):
        async with AsyncSession(self.database_service.engine) as session:
            st = select(ActivityRequest) \
                .where(ActivityRequest.id == activity_request_id) \
                .limit(1)
            result = (await session.execute(st)).first()

            if result:
                return result[0]

    async def get_image_from_activity_request(self, activity_request_id: int):
        activity_request = await self.get_activity_request_by_id(activity_request_id)

        return FileResponse(activity_request.image_path)
