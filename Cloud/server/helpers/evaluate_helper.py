import re
import numpy as np


def evaluate_expression(
    vectors: dict[str, list[float]], expression: str
) -> list[float] | float:
    vectors_np = {k: np.array(v) for k, v in vectors.items()}
    expression = expression.replace(" ", "")

    # Recursive parser for evaluating vector expressions
    def parse_expression(expr: str) -> str:
        # Regex pattern for (dot) and (cross) operations
        pattern = r"(\w+\([^\)]+\)|[a-zA-Z]\w*|\(.*?\))\s*\((dot|cross)\)\s*(\w+\([^\)]+\)|[a-zA-Z]\w*|\(.*?\))"

        # Replace operations until no more matches are found
        while True:
            match = re.search(pattern, expr)
            if not match:
                break  # No more operations to process

            # Extract matched groups
            left, operator, right = match.groups()

            # Determine the replacement based on the operator
            if operator == "cross":
                replacement = f"np.cross({left},{right})"
            elif operator == "dot":
                replacement = f"np.dot({left},{right})"
            else:
                raise ValueError(f"Unsupported operator: {operator}")

            # Replace the matched operation in the expression
            expr = expr[: match.start()] + replacement + expr[match.end() :]

        # Evaluate scalar multiplications inside parentheses
        expr = re.sub(r"\((.*?)\)", lambda m: f"({parse_expression(m.group(1))})", expr)

        return expr

    # Parse and evaluate the expression
    try:
        parsed_expression = parse_expression(expression)

        # Evaluate the parsed expression
        result = eval(
            parsed_expression,
            {"__builtins__": None},
            {
                **vectors_np,
                "np": np,
            },
        )
        if isinstance(result, np.ndarray):
            return result.tolist()
        return result

    except Exception as e:
        raise ValueError(f"Error evaluating expression: {e}")
