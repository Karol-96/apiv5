#!/bin/bash
cd /home/site/wwwroot
source antenv/bin/activate
gunicorn --config gunicorn.conf.py app:app