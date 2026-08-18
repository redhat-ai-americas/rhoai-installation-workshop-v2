# ODF NooBaa

This section installs OpenShift Data Foundation and deploys a NooBaa-backed object storage instance for pipeline artifacts and other S3-compatible workloads.

## Documentation

- [Red Hat OpenShift Data Foundation 4.20 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20)
- [Deploying OpenShift Data Foundation on any platform](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/deploying_openshift_data_foundation_on_any_platform/index)
- [OpenShift Data Foundation architecture](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/red_hat_openshift_data_foundation_architecture/index)
- [Managing hybrid and multicloud resources](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/managing_hybrid_and_multicloud_resources/index)

## Setup Steps

### 00 - ODF Operator

Installs the OpenShift Data Foundation operator from OperatorHub.

**Documentation:** [Installing Red Hat OpenShift Data Foundation Operator](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.20/html/deploying_openshift_data_foundation_on_any_platform/index)

```bash
oc apply -k configs/06-odf-noobaa/00-odf-operator
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
