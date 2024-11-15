from pydantic import BaseModel


class EvaluationInput(BaseModel):
    vectors: dict[str, list[float]]
    expressions: list[str]
