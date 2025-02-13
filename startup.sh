#!/bin/bash
cd /home/site/wwwroot
source /home/site/wwwroot/antenv/bin/activate
gunicorn --worker-class uvicorn.workers.UvicornWorker --bind=0.0.0.0:8000 app:app