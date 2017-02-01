#!/bin/bash

set -e -x

docker build -t dainco/algobox-gateway ./docker/algobox-gateway

cd java/algobox
gradle algobox-api:clean algobox-api:test algobox-api:shadowJar
docker build -t dainco/algobox-api ./algobox-api
gradle algobox-datacollector:clean algobox-datacollector:test algobox-datacollector:shadowJar
docker build -t dainco/algobox-datacollector ./algobox-datacollector

cd ../../python
docker build -t dainco/algobox-jupyter ./algobox
docker build -t dainco/algobox-scheduler ./scheduler

if [[ "${TRAVIS_BRANCH}" == "master" ]]; then
  docker login -u="${DOCKER_USERNAME}" -p="${DOCKER_PASSWORD}";
  docker push dainco/algobox-api
  docker push dainco/algobox-datacollector
  docker push dainco/algobox-gateway
  docker push dainco/algobox-jupyter
  docker push dainco/algobox-scheduler
fi

