import os

import jwt
from jwt import DecodeError


class JWTService:
    def __init__(self):
        self.jwt_secret = os.environ.get("JWT_SECRET") or "JWT_SECRET"

    def generate_jwt(self, user_id: int):
        return jwt.encode({"user_id": user_id}, self.jwt_secret, algorithm="HS256")

    def check_jwt(self, jwt_token: str):
        try:
            return jwt.decode(jwt_token, self.jwt_secret, algorithms=["HS256"], verify=True)
        except DecodeError:
            return False