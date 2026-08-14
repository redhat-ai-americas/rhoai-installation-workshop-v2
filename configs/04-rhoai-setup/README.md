# RHOAI Setup

This section installs and configures Red Hat OpenShift AI on the cluster.

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Installing and uninstalling OpenShift AI Self-Managed](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/index)
- [Administer OpenShift AI platform access, apps, and operations](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/index)
- [Managing observability](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai)
- [Configuring your model-serving platform](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/configuring_your_model-serving_platform/index)

## Setup Steps

### 00 - RHOAI Operator

Installs the Red Hat OpenShift AI operator from OperatorHub.

**Documentation:** [Installing the Red Hat OpenShift AI Operator](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/installing_and_uninstalling_openshift_ai_self-managed/index#installing-the-red-hat-openshift-ai-operator)

```bash
oc apply -k configs/04-rhoai-setup/00-rhoai-operator
```

### 01 - DataScienceCluster

Creates the DataScienceCluster instance that enables OpenShift AI components such as the dashboard, workbenches, KServe, and training.

**Documentation:** [Installing and managing Red Hat OpenShift AI components](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/installing-and-deploying-openshift-ai_install)

```bash
oc apply -k configs/04-rhoai-setup/01-datasciencecluster
```

### 02 - Observability

Configures DSCInitialization monitoring settings and creates the Models as a Service tenant with telemetry enabled.

**Documentation:** [Enabling the observability stack](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#enabling-the-observability-stack), [Collecting metrics from user workloads](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#collecting-metrics-from-user-workloads)

```bash
oc apply -k configs/04-rhoai-setup/02-observability
```

### 03 - Inference Gateway

Creates the OpenShift AI inference Gateway used to route traffic to model-serving workloads.

**Documentation:** [Configuring your model-serving platform](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/configuring_your_model-serving_platform/index)

```bash
oc apply -k configs/04-rhoai-setup/03-inference-gateway
```

### 04 - MaaS Gateway

Creates the Models as a Service gateway, route, and TLS configuration for authenticated model access.

**Documentation:** [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas), [MaaS Namespace Security Knowledge Base](https://access.redhat.com/solutions/7145755)

```bash
oc apply -k configs/04-rhoai-setup/04-maas-gateway
```

### 05 - MaaS Database

Deploys a PostgreSQL database used by Models as a Service.

**Documentation:** [Govern LLM access with Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/index)

```bash
oc apply -k configs/04-rhoai-setup/05-maas-database
```

### 06 - MaaS Connection

Creates the database connection secret that links Models as a Service to the PostgreSQL database.

**Documentation:** [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

```bash
oc apply -k configs/04-rhoai-setup/06-maas-connection
```

### 07 - MLflow

Deploys an MLflow instance for experiment tracking and model artifacts.

**Documentation:** [Install and configure MLflow](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_mlflow/installing-mlflow_mlflow)

```bash
oc apply -k configs/04-rhoai-setup/07-mlflow
```

### 08 - Hardware Profiles

Creates NVIDIA GPU hardware profiles for model serving and workbench workloads in the OpenShift AI dashboard.

**Documentation:** [Working with hardware profiles](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_accelerators/working-with-hardware-profiles_accelerators)

```bash
oc apply -k configs/04-rhoai-setup/08-hardware-profiles
```

### 09 - Dashboard Customization

Customizes the OpenShift AI dashboard, including Gen AI Studio, observability, and available serving runtime templates.

**Documentation:** [Enable the observability dashboard in the UI](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#enable-the-observability-dashboard-in-the-ui), [Administer OpenShift AI platform access, apps, and operations](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/index)

```bash
oc apply -k configs/04-rhoai-setup/09-dashboard-customization
```

## Additional Steps

A number of additional items can be reviewed at this stage.

Review the configuration of the MaaS Gateway, including the host URL configuration requirements, and the gateway namespace admissions requirements.

Review the MaaS Database and the connection details.

The MLFlow instance should now be accessible.

The hardware profiles can be reviewed.

The Serving Runtime customizations can be reviewed.

The dev user should now be able to create a workbench.
