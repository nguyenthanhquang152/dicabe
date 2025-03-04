FROM python:3.8.1-slim

ENV PYTHONUNBUFFERED 1

EXPOSE 80
WORKDIR /app


RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY poetry.lock pyproject.toml ./
RUN rm -Rf /app/.venv
RUN pip install poetry==1.1 && \
    poetry config virtualenvs.in-project false && \
    poetry install --no-dev

COPY . ./

CMD poetry run alembic upgrade head && \
    poetry run uvicorn --host=0.0.0.0 --port=80 app.main:app
