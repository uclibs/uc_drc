#!/bin/bash
# Bash script to pull current main branch and build in docker
# - created for auto deployment to sandbox

docker-compose -f /opt/rails-apps/deric/uc_drc/docker-compose.yml down
cd /opt/rails-apps/deric/uc_drc && git pull 
docker-compose -f /opt/rails-apps/deric/uc_drc/docker-compose.yml up -d --build

