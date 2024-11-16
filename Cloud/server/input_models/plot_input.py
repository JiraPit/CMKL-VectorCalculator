from pydantic import BaseModel


class PlotInput(BaseModel):
    vectors: dict[str, list[float]]
    id: str
