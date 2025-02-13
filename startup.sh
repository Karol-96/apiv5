#!/bin/bash
cd /home/site/wwwroot
source antenv/bin/activate
python -m gunicorn app:app --bind=0.0.0.0:8000 --worker-class uvicorn.workers.UvicornWorker