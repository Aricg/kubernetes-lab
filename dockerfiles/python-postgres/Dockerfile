# Use an official Python runtime as the base image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy the application and the requirements file into the container
COPY app.py /app/
COPY requirements.txt /app/

# Install required packages
RUN pip install --no-cache-dir -r requirements.txt

# Specify the command to run on container start
CMD ["python", "/app/app.py"]

