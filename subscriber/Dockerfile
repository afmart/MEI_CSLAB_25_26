FROM debian:13-slim

RUN apt update && \
    apt install -y \
    ca-certificates \
    python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir paho-mqtt ascon

# Use venv Python by default
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

COPY subscriber.py .

CMD ["python3", "-u","subscriber.py"]