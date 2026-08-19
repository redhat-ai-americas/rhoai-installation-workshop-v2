# ODF NooBaa

Installs OpenShift Data Foundation and deploys a NooBaa-backed object storage instance for pipeline artifacts and other S3-compatible workloads.


## Objectives

- Provide S3-compatible object storage on-cluster for Data Science Pipelines and other RHOAI use cases

## Rationale

Data Science Pipelines uses object storage to pass artifacts between pipeline stages. Object storage is a basic requirement for most RHOAI workflows—not all components inherit high availability from the cluster automatically.

## Takeaways

- NooBaa (Multi-Cloud Gateway) exposes an S3-compatible API via ODF
- Alternatives include Amazon S3, Ceph RADOS Gateway, MinIO, and partner object stores
- Pipeline servers also need an external database; this workshop uses MariaDB in the DSPA manifest (section 07)
- ObjectBucketClaims provision buckets against the NooBaa storage class

## Documentation

- [Red Hat OpenShift Data Foundation 4.20 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20)
- [Deploying OpenShift Data Foundation on any platform](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/deploying_openshift_data_foundation_on_any_platform/index)
- [OpenShift Data Foundation architecture](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/red_hat_openshift_data_foundation_architecture/index)
- [Managing hybrid and multicloud resources](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/index)
- [Object Bucket Claim](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/object-bucket-claim)
- [Connect your workbench to S3-compatible object storage](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_data_in_an_s3-compatible_object_store/index)

## Setup Steps

### 00 - ODF Operator

Installs the OpenShift Data Foundation operator from OperatorHub.

**Documentation:** [Installing Red Hat OpenShift Data Foundation Operator](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/deploying_openshift_data_foundation_on_any_platform/index)

```bash
oc apply -k configs/06-odf-noobaa/00-odf-operator
```

**Validation:**

```bash
oc get csv -n openshift-storage
```

### 01 - Optional ODF Console Plugin

Enables the OpenShift Data Foundation console plugin in the OpenShift console.

**Documentation:** [OpenShift Data Foundation operators](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/red_hat_openshift_data_foundation_architecture/openshift_data_foundation_operators)

```bash
oc apply -k configs/06-odf-noobaa/01-optional-odf-console-plugin
```

### 02 - NooBaa Instance

Creates a StorageCluster with a standalone NooBaa multi-cloud gateway for S3-compatible object storage.

**Documentation:** [Object Bucket Claim](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/object-bucket-claim)

```bash
oc apply -k configs/06-odf-noobaa/02-noobaa-instance
```

**Validation:**

```bash
oc get storagecluster -n openshift-storage
oc get noobaa -n openshift-storage
oc get storageclass | grep noobaa
```

After NooBaa is ready, continue with [07 - AI Pipelines](configs/07-ai-pipelines/README.md) to create an ObjectBucketClaim and DataSciencePipelinesApplication.


