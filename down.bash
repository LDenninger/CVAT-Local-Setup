#!/bin/bash

cd cvat
docker compose -f docker-compose.yml -f docker-compose.dev.yml -f components/serverless/docker-compose.serverless.yml down
cd ..
