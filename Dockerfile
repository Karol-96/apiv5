FROM python:3.11-slim

WORKDIR /app



# Install system dependencies and ODBC Driver
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    unixodbc \
    unixodbc-dev \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y \
        msodbcsql18 \
        mssql-tools18 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify ODBC installation
RUN odbcinst -j && cat /etc/odbcinst.ini

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Make the startup script executable
RUN chmod +x startup.sh

# Set environment variables
ENV ODBCSYSINI=/etc
ENV ODBCINI=/etc/odbc.ini
ENV ACCEPT_EULA=Y

# Update the connection string to use ODBC Driver 18
ENV AZURE_SQL_CONNECTIONSTRING="Driver={ODBC Driver 18 for SQL Server};Server=10.10.1.4.database.windows.net;Database=RAModule2;Uid=karol_bhandari;Pwd=P@ssword7178!;Encrypt=yes;TrustServerCertificate=yes;Connection Timeout=60;"

EXPOSE 8000

CMD ["./startup.sh"]