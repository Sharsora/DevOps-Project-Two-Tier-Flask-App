FROM python:3.9-slim 

WORKDIR /app

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y gcc default-libmysqlclient-dev pkg-config \
&& rm -rf /var/lib/apt/lists/*   # to clear cache, to reduce image size

COPY requirement.txt .

RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirement.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
