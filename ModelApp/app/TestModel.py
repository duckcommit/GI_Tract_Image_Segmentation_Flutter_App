from pydantic import BaseModel

class TestParams(BaseModel):
    image: str
    