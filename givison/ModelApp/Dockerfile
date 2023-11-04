# Use the official Python image as the base
FROM tensorflow/tensorflow:latest

# Set the working directory in the container
WORKDIR /app/app

# Copy the requirements file into the container
COPY . /app/app/

# Install the Python dependencies
RUN pip install -r requirements.txt
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
RUN ls -a

# Expose the port that the FastAPI app will be listening on
EXPOSE 8000

# Start the FastAPI application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# docker run -p 8000:8000 -ip 0.0.0.0 -d project-image