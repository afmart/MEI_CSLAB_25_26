FROM debian:13-slim

RUN apt-get update && \
    apt-get install -y python3 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY server.py .
COPY server.crt .
COPY server.key .

CMD ["python3", "-u", "server.py"]