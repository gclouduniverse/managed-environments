#!/bin/bash

# Copyright 2021 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Get current notebooks STAGING environment
STAGING_ENV=$(gcloud notebooks environments describe ${IMAGE_NAME}.staging --location=${LOCATION} 2> /dev/null)
if [ -z "${STAGING_ENV}" ] # True if string lenght is zero
then
  printf "Notebooks STAGING environment '${IMAGE_NAME}.staging' not found.\nCannot create corresponding PROD environment.\n"
  exit 1
fi  
printf "Notebooks STAGING environment '${IMAGE_NAME}.staging' found:\n${STAGING_ENV}\n"

# Get SHA from STAGING environment
STAGING_SHA=$(printf "${STAGING_ENV}" | sed -n 's/.*tag: //p')
if [ -z "${STAGING_SHA}" ] 
then
  printf "Notebooks STAGING environment '${IMAGE_NAME}.staging' does not have a container tag SHA.\nCannot create corresponding PROD environment.\n"
  exit 1
fi

# Get current notebooks PROD environment
PROD_ENV=$(gcloud notebooks environments describe ${IMAGE_NAME}.production --location=${LOCATION} 2> /dev/null)
if [ ! -z "${PROD_ENV}" ]
then
  printf "Notebooks PROD environment '${IMAGE_NAME}.production' found:\n${PROD_ENV}\n"

  # Get SHA from PROD environment
  PROD_SHA=$(printf "${PROD_ENV}" | sed -n 's/.*tag: //p')
  if [ -z "${PROD_SHA}" ] 
  then
    printf "Notebooks PROD environment '${IMAGE_NAME}.production' does not have a container tag SHA.\nCannot create corresponding FALLBACK environment.\n"
  else
    # Create a notebook FALLBACK environment using the PROD SHA
    gcloud notebooks environments delete ${IMAGE_NAME}.fallback --location=${LOCATION} &> /dev/null
    gcloud notebooks environments create ${IMAGE_NAME}.fallback --location=${LOCATION} \
      --container-repository=gcr.io/${PROJECT_ID}/${IMAGE_NAME} \
      --container-tag=${PROD_SHA} \
      --display-name=${IMAGE_NAME}.fallback
    printf "Notebook FALLBACK environment '${IMAGE_NAME}.fallback' created\n"
    gcloud notebooks environments describe ${IMAGE_NAME}.fallback --location=${LOCATION}  
  fi

  # Delete old notebooks PROD environment
  gcloud notebooks environments delete ${IMAGE_NAME}.production --location=${LOCATION} &> /dev/null
fi

# Create the new notebook PROD environment using the STAGING SHA
gcloud notebooks environments create ${IMAGE_NAME}.production --location=${LOCATION} \
  --container-repository=gcr.io/${PROJECT_ID}/${IMAGE_NAME} \
  --container-tag=${STAGING_SHA} \
  --display-name=${IMAGE_NAME}.production

# Describe the new notebooks PROD environment for the logs
printf "Notebooks PROD environment '${IMAGE_NAME}.production' created\n"
gcloud notebooks environments describe ${IMAGE_NAME}.production --location=${LOCATION}  