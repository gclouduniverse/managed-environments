FROM gcr.io/deeplearning-platform-release/tf-gpu.1-15

# Install Notebook Scheduler extension
ARG EXTENSION_BUCKET="gs://deeplearning-platform-ui-public"
ARG EXT="jupyterlab_gcpscheduler-latest.tar.gz"
ARG URL="${EXTENSION_BUCKET}/${EXT}"
RUN gsutil cp "${URL}" "/tmp/${EXT}"
RUN pip install "/tmp/${EXT}"

RUN jupyter lab build

# Install other dependencies
RUN pip install --user --upgrade setuptools