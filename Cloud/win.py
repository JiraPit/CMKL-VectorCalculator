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

# Function to add two vectors (ignoring color)
def add_vectors(v1, v2):
    return [int(v1[i] + v2[i]) for i in range(3)]  # Convert results to int

# Function to subtract two vectors (ignoring color)
def subtract_vectors(v1, v2):
    return [int(v1[i] - v2[i]) for i in range(3)]  # Convert results to int

# Function to multiply two vectors element-wise (ignoring color)
def multiply_vectors(v1, v2):
    return [int(v1[i] * v2[i]) for i in range(3)]  # Convert results to int

# Perform example operations
addition_result = add_vectors(coordinates[0], coordinates[1])
subtraction_result = subtract_vectors(coordinates[0], coordinates[1])
multiplication_result = multiply_vectors(coordinates[0], coordinates[1])

# Output results
print("Addition of first and second vectors:", addition_result)
print("Subtraction of first and second vectors:", subtraction_result)
print("Element-wise multiplication of first and second vectors:", multiplication_result)
