from pydantic import BaseModel

class Temperature(BaseModel):
    value: float

    def checkRange(self) -> bool:
        return self.value in range(-100, 100)

class Humid(BaseModel):
    value: float

    def checkRange(self) -> bool:
        return self.value in range(0, 100)