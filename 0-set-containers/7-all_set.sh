#!/bin/bash
set -e
set -o pipefail

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 1-ckan_set.sh

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 2-prov_set.sh

cd ${WORKDIR}/klab-connector-v4/misc/authorization
./image_build_fastapi.sh
./image_build_keycloak.sh
docker image ls | grep fastapi
docker image ls | grep keycloak

cd ${WORKDIR}/klab-connector-v4/misc/authorization
./image_build_fastapi.sh
./image_build_keycloak.sh
docker image ls | grep fastapi
docker image ls | grep keycloak

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 3-authz_set.sh

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 4-cons_set.sh

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 5-webapp_set.sh

cd ${WORKDIR}/data-share-handson-scripts/0-set-containers
bash 6-http-server_set.sh
