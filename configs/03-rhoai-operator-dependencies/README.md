# RHOAI Operator Dependencies

This section installs operators and supporting configuration that Red Hat OpenShift AI depends on.

## Setup Steps

### 00 - LeaderWorkerSet Operator

Installs the LeaderWorkerSet operator used for multi-node distributed workloads.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/00-leaderworkerset-operator
```

### 01 - LeaderWorkerSet Instance

Creates the LeaderWorkerSetOperator instance that manages the LeaderWorkerSet components on the cluster.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/01-leaderworkerset-instance
```

### 02 - JobSet Operator

Installs the JobSet operator used to manage distributed training jobs with KubeFlow Training Operator.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/02-jobset-operator
```

### 03 - OpenTelemetry Operator

Installs the Red Hat build of OpenTelemetry operator for collecting and exporting telemetry data.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/03-opentelemetry-operator
```

### 04 - Tempo Operator

Installs the Tempo operator for distributed tracing support.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/04-tempo-operator
```

### 05 - Cluster Observability Operator

Installs the Cluster Observability operator used by OpenShift AI observability features.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/05-cluster-observability-operator
```

### 06 - Connectivity Link Operator

Installs the Red Hat Connectivity Link (Kuadrant) operator for API gateway and authorization capabilities.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/06-connectivity-link-operator
```

### 07 - Optional Connectivity Link Console Plugin

Enables the Connectivity Link console plugin in the OpenShift console.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/07-optional-connectivity-link-console-plugin
```

### 08 - Connectivity Link Kuadrant

Creates the Kuadrant instance that configures Connectivity Link on the cluster.

```bash
oc apply -k configs/03-rhoai-operator-dependencies/08-connectivity-link-kuadrant
```

### 09 - Connectivity Link TLS Setup

Configures TLS for Authorino using the OpenShift service serving certificate.

```bash
./configs/03-rhoai-operator-dependencies/09-connectivity-link-tls-setup.sh
```
