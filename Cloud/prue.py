import plotly.graph_objects as go


# Function to plot 3D vectors and save the plot as HTML plot.html
def plot_3d_vectors(vectors):
    # Create a 3D line plot with vectors
    fig = go.Figure()

    # Loop through all line arrays in vectors array and add them to the plot
    for i, vector in enumerate(vectors):
        # Extract the color from the last element of the vector
        color = vector[-1]
        # Extract the coordinates from the vector
        x, y, z = vector[:-1]

        fig.add_trace(
            go.Scatter3d(
                x=[0, x],
                y=[0, y],
                z=[0, z],
                mode="lines+markers",
                name=f"Vector {i+1}",
                line=dict(color=color),
            )
        )

    # Set plot title and labels
    fig.update_layout(
        title="3D Vector Plot",
        scene=dict(xaxis_title="X axis", yaxis_title="Y axis", zaxis_title="Z axis"),
    )

    # Generate HTML for the plot
    html_content = fig.to_html()

    # Save the HTML content to a file
    with open("plot.html", "w", encoding="utf-8") as f:
        f.write(html_content)


# Format: [x, y, z, color(hex)]
# Example usage
vectors = [
    [1, 10, 5, "#1f77b4"],  # Blue
    [2, 20, 15, "#ff7f0e"],  # Orange
    [3, 25, 20, "#2ca02c"],  # Green
]

plot_3d_vectors(vectors)
