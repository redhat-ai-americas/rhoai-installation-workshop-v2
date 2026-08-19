# AI Pipelines

Configures Data Science Pipelines and deploys a sample Iris classification pipeline using NooBaa object storage.


## Objectives

- Deploy a DataSciencePipelinesApplication (DSPA) with MariaDB metadata store and NooBaa-backed object storage
- Grant the `dev` user access to run pipelines in the example project
- Install the Iris training Kubeflow pipeline

## Rationale

Best practice uses an external database for pipeline metadata. Pipelines use S3-compatible storage to pass data between stages—configure object storage before enabling the pipeline server.

## Takeaways

- DSPA object storage is configured via secrets and ObjectBucketClaims on NooBaa
- Namespace labels (`opendatahub.io/dashboard=true`) expose projects in the OpenShift AI dashboard
- Validation: open **Develop & Train** > **Pipelines** in the dashboard and run the Iris pipeline

## Prerequisites

- [06 - ODF NooBaa](configs/06-odf-noobaa/README.md) — NooBaa storage class and bucket provisioner available
- [04 - RHOAI Setup](configs/04-rhoai-setup/README.md) — DataScienceCluster with pipelines component enabled

## Documentation

- [Build, schedule, and track machine learning pipelines](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_ai_pipelines/index)
- [Connect your workbench to S3-compatible object storage](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_data_in_an_s3-compatible_object_store/index)
- [Working with certificates](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/working-with-certificates_certs)
- [Object Bucket Claim (ODF)](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/object-bucket-claim)
- [Configuring a pipeline server](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/working_with_ai_pipelines/index#configuring-a-pipeline-server)


## Setup Steps

### 00 - Pipeline Example Namespace

Creates the `ai-pipeline-example` namespace with labels required for the OpenShift AI dashboard.

**Documentation:** [Organize projects, collaborate in workbenches, and deploy models](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/organize_projects_collaborate_in_workbenches_and_deploy_models/index)

```bash
oc apply -k configs/07-ai-pipelines/00-pipeline-example-namespace
```

### 01 - Dev User RBAC

Grants the `dev` user `edit` access in the `ai-pipeline-example` namespace so workshop participants can create and run pipelines from the dashboard.

**Documentation:** [Organize projects, collaborate in workbenches, and deploy models](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/organize_projects_collaborate_in_workbenches_and_deploy_models/index)

```bash
oc apply -k configs/07-ai-pipelines/01-dev-user-rbac
```

### 02 - DSPA Instance

Deploys a DataSciencePipelinesApplication with MariaDB and object storage backed by an ObjectBucketClaim on NooBaa.

**Documentation:** [Configuring a pipeline server](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/working_with_ai_pipelines/index#configuring-a-pipeline-server)

```bash
oc apply -k configs/07-ai-pipelines/02-dspa-instance
```

**Validation:**

```bash
oc get datasciencepipelinesapplication -n ai-pipeline-example
oc get pods -n ai-pipeline-example
```

Wait for the pipeline server and MariaDB pods to reach Ready.

### 03 - Iris Pipeline

Creates the Iris classification Kubeflow pipeline and pipeline version.

**Documentation:** [Build, schedule, and track machine learning pipelines](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_ai_pipelines/index)

**Source:** [kubeflow-pipelines-examples — Iris training pipeline](https://github.com/redhat-ai-services/kubeflow-pipelines-examples/blob/main/pipelines/11_iris_training_pipeline.py)

```bash
oc apply -k configs/07-ai-pipelines/03-iris-pipeline
```

See also [configs/07-ai-pipelines/03-iris-pipeline/README.md](03-iris-pipeline/README.md).

**Validation:** In the OpenShift AI dashboard, open **Develop & Train** > **Pipelines** > project `ai-pipeline-example`. Instantiate a run of the Iris pipeline from the actions menu.

## Additional Steps

Trigger a pipeline run through the OpenShift AI Dashboard.
