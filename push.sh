#!/bin/bash -xe
docker build -t classifier:$(git rev-parse --short HEAD) -f Dockerfile .
docker tag classifier:$(git rev-parse --short HEAD) localhost:5000/classifier:$(git rev-parse --short HEAD)
docker tag classifier:$(git rev-parse --short HEAD) localhost:5000/classifier:latest
docker push localhost:5000/classifier:latest
docker push localhost:5000/classifier:$(git rev-parse --short HEAD)
git push origin $(git rev-parse --short HEAD):build/$(git rev-parse --short HEAD)
