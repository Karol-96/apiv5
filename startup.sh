#!/bin/bash
cd /home/site/wwwroot
pip install -r requirements.txt
gunicorn -w 4 -k uvicorn.workers.UvicornWorker api_flask:app --bind=0.0.0.0:8000 --timeout 600