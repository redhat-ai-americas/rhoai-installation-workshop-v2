# AI Pipelines

This section configures Data Science Pipelines and deploys a sample Iris classification pipeline using NooBaa object storage.

## Setup Steps

### 00 - Pipeline Example Namespace

Creates the `ai-pipeline-example` namespace with labels required for the OpenShift AI dashboard.

```bash
oc apply -k configs/07-ai-pipelines/00-pipeline-example-namespace
```

### 01 - DSPA Instance

Deploys a DataSciencePipelinesApplication with MariaDB and object storage backed by an ObjectBucketClaim on NooBaa.

Apply the ObjectBucketClaim first, wait for the bucket to be provisioned, then set the bucket name in `dspa.yaml` before applying the DSPA (or patch the live DSPA after apply):

```bash
oc apply -k configs/07-ai-pipelines/01-dspa-instance/obc.yaml
oc wait --for=condition=Bound objectbucketclaim/data-science-pipelines -n ai-pipeline-example --timeout=120s
oc get objectbucket obc-ai-pipeline-example-data-science-pipelines \
  -o jsonpath='{.spec.endpoint.bucketName}{"\n"}'
# Update spec.objectStorage.externalStorage.bucket in dspa.yaml, then:
oc apply -k configs/07-ai-pipelines/01-dspa-instance
```

Object storage is configured for in-cluster HTTP (`s3.openshift-storage.svc:80`) so pipeline task pods can read/write artifacts without trusting the NooBaa HTTPS certificate.

#### Troubleshooting: `x509: certificate signed by unknown authority` on S3

If a pipeline step fails downloading artifacts from `https://s3.openshift-storage.svc:443` with TLS errors, the `train-model` step (or any step that reads upstream artifacts from object storage) cannot verify NooBaa's certificate. The first step (`data-prep`) often succeeds because it only uploads artifacts.

**Cause:** NooBaa's S3 route uses a cert signed by `openshift-service-serving-signer`. The DSP API server may still report `ObjectStoreAvailable` because it uses a different CA path (`/dsp-custom-certs`), but KFP launcher pods use the system CA bundle path for S3 and do not include the OpenShift service CA in `dsp-trusted-ca-dspa`.

**Fix (recommended for this workshop):** Use HTTP for in-cluster object storage:

```bash
oc patch dspa dspa -n ai-pipeline-example --type=merge -p \
  '{"spec":{"objectStorage":{"externalStorage":{"host":"s3.openshift-storage.svc","port":"80","scheme":"http"}}}}'
```

Wait for the `kfp-launcher` ConfigMap to reconcile (`disableSSL: true` / `http://` endpoint), then re-run the pipeline.

**Fix (keep HTTPS):** Add the OpenShift service CA to the DSPA and restart the pipeline server:

```bash
oc get configmap openshift-service-ca.crt -n openshift-storage \
  -o jsonpath='{.data.service-ca\.crt}' > /tmp/service-ca.crt
oc create configmap dsp-pipeline-service-ca -n ai-pipeline-example \
  --from-file=service-ca.crt=/tmp/service-ca.crt --dry-run=client -o yaml | oc apply -f -
oc patch dspa dspa -n ai-pipeline-example --type=merge -p \
  '{"spec":{"apiServer":{"cABundle":{"configMapName":"dsp-pipeline-service-ca","configMapKey":"service-ca.crt"}}}}'
```

### 02 - Iris Pipeline

Creates the Iris classification Kubeflow pipeline and pipeline version for running a sample ML workflow.

```bash
oc apply -k configs/07-ai-pipelines/02-iris-pipeline
```
