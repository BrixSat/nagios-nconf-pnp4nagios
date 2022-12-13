#!/bin/bash
docker run -d -e "stack=geo" -e "colo=hkg1" -p 8082:80 -i -t nagiosnconf:latest
