from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.middleware.cors import CORSMiddleware
from server.input_models.evaluate_input import EvaluationInput
from server.input_models.plot_input import PlotInput
from server.helpers.evaluate_helper import evaluate_expression
from server.helpers.plot_helper import plot_3d_vectors

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


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
                if len(result) != 3:
                    result = "ERROR"
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
)
def plot(input_data: PlotInput):
    try:
        plot_3d_vectors(input_data.id, input_data.vectors)
        return "OK"
    except Exception as e:
        print(e)
        raise HTTPException(
            status_code=400,
            detail="Error plotting vectors",
        )


@app.get(
    "/get_plot/{id}",
    response_class=HTMLResponse,
)
def get_plot(id: str):
    try:
        with open(f"server/tmp/plots/plot_{id}.html", "r") as f:
            return f.read()
    except Exception as e:
        print(e)
        raise HTTPException(
            status_code=404,
            detail="Plot not found",
        )
