#!/bin/bash
docker exec -ti  $(docker ps -a | grep nagiosnconf:latest | awk '{print $1}') bash
