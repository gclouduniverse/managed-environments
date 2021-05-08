# AI Platform Notebooks Upgrades and Dependency Management

Sample [Cloud Build][cloud-build] pipelines for
[AI Platform Notebooks][caip-notebooks] upgrades and dependency management.

<!-- Add paragraph and link to best practices & process doc when available -->

## How-to use

0 - Prepare:

*   Clone this repository.
*   Choose a [Deep Learning Container (DLCs)][dlc] image and specifiy it in the [Dockerfile](Dockerfile)
*   Add notebook dependencies to the [Dockerfile](Dockerfile).
*   Add notebooks for automated testing in folder [test_notebooks](test_notebooks)
*   Specify an `_IMAGE_NAME` in each of of the pipeline yaml files.

1 - Publish staging image:

*   Create a [trigger][trigger] to run the [staging pipeline](cloudbuild-staging.yaml)
on each commit to branch called `staging`.
*   Commit into to the `staging` branch and push to your own remote repository.
*   Cloud Build automatically runs the [test_notebooks](test_notebooks)
and creates the staging image.

2 - Test staging image

*   (Optional) [Create notebook instances][gc-nb-instances-create] to manually test image
using the `staging` environment.

```sh
  gcloud notebooks instances create <INSTANCE_NAME> \
    --location=<NOTEBOOK_LOCATION> \
    --environment=<IMAGE_NAME>.staging
```

*   Access your instance from the [AI Platform Notebooks console][caip-console]

3 - Publish production image:

*   Create a [trigger][trigger] to run the [production pipeline](cloudbuild-prod.yaml)
on each commit to a branch called `production`.
*   Commit into the `production` branch and push to your own remote repository.
*   Cloud Build creates the production image.

4 - [Create notebook instances][gc-nb-instances-create] using image from the `production`
environment

```sh
  gcloud notebooks instances create <INSTANCE_NAME> \
    --location=<NOTEBOOK_LOCATION> \
    --environment=<IMAGE_NAME>.production
```

*   Access your instance from the [AI Platform Notebooks console][caip-console]

Both pipelines use the original [commit SHA][sha] as the [Docker tag][docker-tag],
representing the [image version ID][image-version] in [Container Registry][container-registry].

## Licensing

```lang-none
Copyright 2021 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Contributing

*   [Contributing guidelines](contributing-guidelines.md)
*   [Code of conduct](code-of-conduct.md)

<!-- LINKS: https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[caip-console]: https://console.cloud.google.com/ai-platform/notebooks/instances
[caip-notebooks]: https://cloud.google.com/ai-platform-notebooks
[cloud-build]: https://cloud.google.com/build
[container-registry]: https://cloud.google.com/container-registry
[dlc]: https://cloud.google.com/ai-platform/deep-learning-containers/docs/choosing-container
[docker-tag]: https://docs.docker.com/engine/reference/commandline/tag/
[gc-nb-instances-create]: https://cloud.google.com/sdk/gcloud/reference/notebooks/instances/create
[image-version]: https://cloud.google.com/container-registry/docs/managing#listing_the_versions_of_an_image
[sha]: https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
[trigger]: https://cloud.google.com/build/docs/automating-builds/create-manage-triggers