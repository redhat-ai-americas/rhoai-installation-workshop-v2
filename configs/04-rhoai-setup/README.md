# RHOAI Setup

This section installs and configures Red Hat OpenShift AI on the cluster.

## Setup Steps

### 00 - RHOAI Operator

Installs the Red Hat OpenShift AI operator from OperatorHub.

```bash
oc apply -k configs/04-rhoai-setup/00-rhoai-operator
```

### 01 - DataScienceCluster

Creates the DataScienceCluster instance that enables OpenShift AI components such as the dashboard, workbenches, KServe, and training.

```bash
oc apply -k configs/04-rhoai-setup/01-datasciencecluster
```

### 02 - Observability

Configures DSCInitialization monitoring settings and creates the Models as a Service tenant with telemetry enabled.

```bash
oc apply -k configs/04-rhoai-setup/02-observability
```

### 03 - Inference Gateway

Creates the OpenShift AI inference Gateway used to route traffic to model-serving workloads.

```bash
oc apply -k configs/04-rhoai-setup/03-inference-gateway
```

### 04 - MaaS Gateway

Creates the Models as a Service gateway, route, and TLS configuration for authenticated model access.

```bash
oc apply -k configs/04-rhoai-setup/04-maas-gateway
```

### 05 - MaaS Database

Deploys a PostgreSQL database used by Models as a Service.

```bash
oc apply -k configs/04-rhoai-setup/05-maas-database
```

### 06 - MaaS Connection

Creates the database connection secret that links Models as a Service to the PostgreSQL database.

```bash
oc apply -k configs/04-rhoai-setup/06-maas-connection
```

### 07 - MLflow

Deploys an MLflow instance for experiment tracking and model artifacts.

```bash
oc apply -k configs/04-rhoai-setup/07-mlflow
```

### 08 - Hardware Profiles

Creates NVIDIA GPU hardware profiles for model serving and workbench workloads in the OpenShift AI dashboard.

```bash
oc apply -k configs/04-rhoai-setup/08-hardware-profiles
```

### 09 - Dashboard Customization

Customizes the OpenShift AI dashboard, including Gen AI Studio, observability, and available serving runtime templates.

```bash
oc apply -k configs/04-rhoai-setup/09-dashboard-customization
```
