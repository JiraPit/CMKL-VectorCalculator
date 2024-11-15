import plotly.graph_objects as go


COLORS = [
    "rgb(0, 0, 255)",  # Blue
    "rgb(0, 255, 0)",  # Green
    "rgb(255, 0, 0)",  # Red
    "rgb(255, 255, 0)",  # Yellow
    "rgb(255, 0, 255)",  # Magenta
    "rgb(0, 255, 255)",  # Cyan
    "rgb(255, 165, 0)",  # Orange
    "rgb(128, 0, 128)",  # Purple
]


def plot_3d_vectors(vectors: dict[str, list[float]]) -> str:
    # Create a 3D line plot with vectors
    fig = go.Figure()

    # Loop through all line arrays in vectors array and add them to the plot
    for i, (name, vector) in enumerate(vectors.items()):
        # Extract the coordinates from the vector
        x, y, z = vector

        fig.add_trace(
            go.Scatter3d(
                x=[0, x],
                y=[0, y],
                z=[0, z],
                mode="lines+markers",
                name=name,
                line=dict(
                    color=COLORS[i % len(COLORS)],
                ),
            )
        )

    # Set plot title and labels
    fig.update_layout(
        title="3D Vector Plot",
        scene=dict(
            xaxis_title="X",
            yaxis_title="Y",
            zaxis_title="Z",
        ),
    )

    # Generate HTML for the plot
    html_content = fig.to_html()

    return html_content
