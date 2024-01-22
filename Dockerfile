FROM python:3.11

WORKDIR /app

COPY requirements.txt /app/requirements.txt

#RUN pip install --upgrade pip

RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

RUN pip install greenlet

COPY . /app

CMD ["python","simulation.py"]