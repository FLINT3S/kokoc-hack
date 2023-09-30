import datetime
import os
import uuid

import aiofiles
from data.database_service import DatabaseService

from data.model.activity_request import ActivityRequest

PATH = os.path.join(os.getcwd())

class ActivityService:
    def __init__(self, database_service: DatabaseService):
        self.database_service = database_service

    async def create_activity_request(self, employee_id: int, training_information: str,
                                      adding_kilocalories_count: int, file):
        content = await file.read()
        file_name = PATH + "/code/public/" + f'{uuid.uuid4().hex}'
        async with aiofiles.open(file_name, "wb") as f:
            await f.write(content)

        activity_request = ActivityRequest(employee_id=employee_id, training_information=training_information,
                                           adding_kilocalories_count=adding_kilocalories_count,
                                           date=datetime.datetime.now(), image_path=file_name)

        return await self.database_service.save(activity_request)
