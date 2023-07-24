#!/bin/bash

cd cvat
export CVAT_HOST=10.60.12.37
docker compose -f docker-compose.yml -f docker-compose.dev.yml -f components/serverless/docker-compose.serverless.yml up -d
cd ..
