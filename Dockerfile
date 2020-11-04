# Use the light version of the image that contains just the latest binary
FROM gcr.io/deeplearning-platform-release/tf-gpu.1-15

RUN pip install --user --upgrade setuptools