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

STAGING_IMAGE_NAME=${IMAGE_NAME}.staging

# Check if the notebooks STAGING environment already exists
STAGING_ENV=$(gcloud notebooks environments describe ${STAGING_IMAGE_NAME} --location=${LOCATION} 2> /dev/null)
if [ $? -eq 0 ]
then
  printf "Notebooks STAGING environment '${STAGING_IMAGE_NAME}' found:\n${STAGING_ENV}\n"
  gcloud notebooks environments delete ${STAGING_IMAGE_NAME} --location=${LOCATION}
fi

# Create the new notebook environment using the new SHA
gcloud notebooks environments create ${STAGING_IMAGE_NAME} --location=${LOCATION} \
  --container-repository=gcr.io/${PROJECT_ID}/${IMAGE_NAME} \
  --container-tag=${COMMIT_SHA} \
  --display-name=${STAGING_IMAGE_NAME}  

# Describe the new notebook environment for the logs
printf "Notebook STAGING environment '${STAGING_IMAGE_NAME}' created:\n"
gcloud notebooks environments describe ${STAGING_IMAGE_NAME} --location=${LOCATION}  
