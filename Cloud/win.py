import numpy as np

# Input data
vectors = [
    [1, 10, 5, '#1f77b4'],  # Blue
    [2, 20, 15, '#ff7f0e'],  # Orange
    [3, 25, 20, '#2ca02c']   # Green
]

# Extract coordinates and colors
coordinates = np.array([vec[:3] for vec in vectors])  # Get only x, y, z values
colors = [vec[3] for vec in vectors]  # Get color codes

# Function to add multiple vectors (ignoring color)
def add_multiple_vectors(vectors):
    result = np.sum(vectors, axis=0)
    return [int(val) for val in result]

# Function to subtract multiple vectors (ignoring color)
def subtract_multiple_vectors(vectors):
    result = vectors[0]  # Start with the first vector
    for vec in vectors[1:]:
        result = np.subtract(result, vec)
    return [int(val) for val in result]

# Function to multiply multiple vectors element-wise (ignoring color)
def multiply_multiple_vectors(vectors):
    result = vectors[0]  # Start with the first vector
    for vec in vectors[1:]:
        result = np.multiply(result, vec)
    return [int(val) for val in result]

# Perform operations on all vectors
addition_result = add_multiple_vectors(coordinates)
subtraction_result = subtract_multiple_vectors(coordinates)
multiplication_result = multiply_multiple_vectors(coordinates)

# Output results
print("Addition of all vectors:", addition_result)
print("Subtraction of all vectors:", subtraction_result)
print("Element-wise multiplication of all vectors:", multiplication_result)
