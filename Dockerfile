FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /app

# Install minimal runtime packages and clean apt cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends gosu ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir --no-compile -r /app/requirements.txt

# Create config directory
RUN mkdir -p /app/config

# Copy application code
COPY source /app/source
COPY main.py /app
COPY template /app/template
COPY assets /app/assets
COPY entrypoint.sh /app/entrypoint.sh
COPY VERSION /app
COPY config/config-example.yml /app/default/config-example.yml

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]