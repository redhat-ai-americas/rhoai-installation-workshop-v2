# ODF NooBaa

This section installs OpenShift Data Foundation and deploys a NooBaa-backed object storage instance for pipeline artifacts and other S3-compatible workloads.

## Setup Steps

### 00 - ODF Operator

Installs the OpenShift Data Foundation operator from OperatorHub.

```bash
oc apply -k configs/06-odf-nooba/00-odf-operator
```

### 01 - Optional ODF Console Plugin

Enables the OpenShift Data Foundation console plugin in the OpenShift console.

```bash
oc apply -k configs/06-odf-nooba/01-optional-odf-console-plugin
```

### 02 - NooBaa Instance

Creates a StorageCluster with a standalone NooBaa multi-cloud gateway for S3-compatible object storage.

```bash
oc apply -k configs/06-odf-nooba/02-nooba-instance
```
