FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY idfm_lines.py main.py ./

ENTRYPOINT ["python", "main.py"]
