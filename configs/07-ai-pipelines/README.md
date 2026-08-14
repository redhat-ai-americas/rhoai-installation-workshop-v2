# AI Pipelines

This section configures Data Science Pipelines and deploys a sample Iris classification pipeline using NooBaa object storage.

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Build, schedule, and track machine learning pipelines](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_ai_pipelines/index)
- [Connect your workbench to S3-compatible object storage](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_data_in_an_s3-compatible_object_store/index)
- [Working with certificates](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/working-with-certificates_certs)
- [Object Bucket Claim (ODF)](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/object-bucket-claim)

## Setup Steps

### 00 - Pipeline Example Namespace

Creates the `ai-pipeline-example` namespace with labels required for the OpenShift AI dashboard.

**Documentation:** [Organize projects, collaborate in workbenches, and deploy models](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/organize_projects_collaborate_in_workbenches_and_deploy_models/index)

```bash
oc apply -k configs/07-ai-pipelines/00-pipeline-example-namespace
```

### 01 - DSPA Instance

Deploys a DataSciencePipelinesApplication with MariaDB and object storage backed by an ObjectBucketClaim on NooBaa.

**Documentation:** [Configuring a pipeline server](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/working_with_ai_pipelines/index#configuring-a-pipeline-server)

```bash
oc apply -k configs/07-ai-pipelines/01-dspa-instance
```

### 02 - Iris Pipeline

Creates the Iris classification Kubeflow pipeline and pipeline version for running a sample ML workflow.

**Documentation:** [Build, schedule, and track machine learning pipelines](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_ai_pipelines/index)

```bash
oc apply -k configs/07-ai-pipelines/02-iris-pipeline
```

See also [configs/07-ai-pipelines/02-iris-pipeline/README.md](02-iris-pipeline/README.md).
