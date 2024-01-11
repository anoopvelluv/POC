FROM python:3.11

COPY requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install --upgrade pip

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install greenlet

COPY . /app

CMD ["python","simulation.py"]