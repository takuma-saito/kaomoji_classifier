#!/bin/bash -xe
$(aws ecr --profile system-docker get-login --no-include-email --region ap-northeast-1)
URL=429084355607.dkr.ecr.ap-northeast-1.amazonaws.com/kaomoji/classifier
tag=$(git --git-dir=.git rev-parse --short HEAD)
docker build -t classifier:$tag -f Dockerfile .
docker tag classifier:$tag $URL:$tag
docker tag classifier:$tag $URL:latest
docker push $URL:latest
docker push $URL:$tag
git --git-dir=.git tag build/$tag
git --git-dir=.git push origin build/$tag:build/$tag
