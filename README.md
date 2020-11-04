# Managed Environments

Sample pipeline set up for managed Google Cloud AI Platform Notebooks environments.

This pipeline builds a custom docker container based on a `gcr.io/deeplearning-platform-release` DL container image, runs tests and then publishes to resulting docker image to production.

The production docker image will be used by the environment.

The following command can be used to create a notebook using this newly created environment:

```
gcloud beta notebooks instances create --environment=YOUR_ENV_NAME --environment-location=YOUR_ENV_LOCATION --location=YOUR_LOCATION
```
