# from https://fastapi.tiangolo.com/deployment/docker/#create-the-fastapi-code
FROM python:3.12.0-slim

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app


CMD ["fastapi", "run", "app/main.py", "--port", "80", "--workers", "4"]
