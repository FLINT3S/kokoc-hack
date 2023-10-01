from pydantic import BaseModel

class ActivityRequestModerateDTO(BaseModel):
    activity_request_id: int
    status: bool