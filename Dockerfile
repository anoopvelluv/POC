FROM python:3.11

WORKDIR /app

COPY requirements.txt /app/requirements.txt

#RUN pip install --upgrade pip

#RUN pip install -r requirements.txt

#RUN pip install greenlet

COPY . /app

CMD ["pip install -r requirements.txt", "python","simulation.py"]