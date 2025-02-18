FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for pymssql
RUN apt-get update && apt-get install -y \
    freetds-dev \
    freetds-bin \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure FreeTDS
RUN echo "[MSSQL]\n\
host = 10.10.1.4\n\
port = 1433\n\
tds version = 7.4" > /etc/freetds.conf

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Make the startup script executable
RUN chmod +x startup.sh

EXPOSE 8000

CMD ["./startup.sh"]