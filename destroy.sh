#!/bin/bash
set -eo pipefail
docker stop  $(docker ps -a | grep nagiosnconf:latest | awk '{print $1}')
docker rm   $(docker ps -a | grep nagiosnconf:latest | awk '{print $1}')
docker system prune -f
