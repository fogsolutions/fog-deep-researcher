#!/usr/bin/env bash

RESROURCE_GROUP=${RESOURCE_GROUP:="rg-fog-demo-dev"}

IMAGE_NAME="crz3zicizv4obfi.azurecr.io/gpt-researcher:latest"
USER_ASSIGNED_IDENTITY_ID="/subscriptions/090002d9-f46e-4923-9960-156e86ba8095/resourcegroups/rg-fog-demo-dev/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-apps-z3zicizv4obfi"
USER_ASSIGNED_IDENTITY_NAME="id-apps-z3zicizv4obfi"
CONTAINER_APPS_ENV="cae-z3zicizv4obfi-01"
REGISTRY="crz3zicizv4obfi"
REGISTRY_SERVER="${REGISTRY}.azurecr.io"
TARGET_PORT=8000

# docker build -t $IMAGE_NAME .
# az acr login --name $REGISTRY
# docker push $IMAGE_NAME
# ./build.sh

az containerapp up --name gpt-researcher \
    --resource-group $RESOURCE_GROUP \
    --environment "${CONTAINER_APPS_ENV}" \
    --env-vars $(awk -F= '{printf "%s=%s ", $1, $2}' ./.env) \
    --image $IMAGE_NAME \
    --user-assigned $USER_ASSIGNED_IDENTITY_NAME \
    --registry-server $REGISTRY_SERVER \
    --registry-identity $USER_ASSIGNED_IDENTITY_ID \
    --ingress external \
    --target-port ${TARGET_PORT} \
    --source .