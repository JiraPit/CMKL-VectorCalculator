from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from server.input_models.evaluate_input import EvaluationInput
from server.input_models.plot_input import PlotInput
from server.helpers.evaluate_helper import evaluate_expression
from server.helpers.plot_helper import plot_3d_vectors

app = FastAPI()


@app.get("/")
def root():
    return "Welcome to CMKL-VectorCalculator"


@app.post(
    "/evaluate",
    response_model=dict[str, list[float] | str],
)
def evaluate(input_data: EvaluationInput):
    try:
        results = {}
        for ex in input_data.expressions:
            try:
                result = evaluate_expression(input_data.vectors, ex)
            except Exception:
                result = "ERROR"
            results[ex] = result

        return results
    except Exception as e:
        print(e)
        raise HTTPException(
            status_code=400,
            detail="Error evaluating expressions",
        )


@app.post(
    "/plot",
    response_class=HTMLResponse,
)
def plot(input_data: PlotInput):
    try:
        return plot_3d_vectors(input_data.vectors)
    except Exception as e:
        print(e)
        raise HTTPException(
            status_code=400,
            detail="Error plotting vectors",
        )
