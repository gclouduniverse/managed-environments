# Copyright 2021 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

FROM gcr.io/deeplearning-platform-release/tf2-gpu.2-4

# Install Notebook Scheduler extension
ARG EXTENSION_BUCKET="gs://deeplearning-platform-ui-public"
ARG EXT="jupyterlab_gcpscheduler-latest.tar.gz"
ARG URL="${EXTENSION_BUCKET}/${EXT}"
RUN gsutil cp "${URL}" "/tmp/${EXT}"
RUN pip install "/tmp/${EXT}"

RUN jupyter lab build

# Install other dependencies
RUN pip install --user --upgrade setuptools