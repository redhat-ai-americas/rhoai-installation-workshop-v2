# RHOAI Operator Dependencies

This section installs operators and supporting configuration that Red Hat OpenShift AI depends on.

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Installing and deploying OpenShift AI](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/installing-and-deploying-openshift-ai_install)
- [Installing distributed workloads components](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/installing-the-distributed-workloads-components_install)
- [Leader Worker Set Operator (OpenShift 4.20)](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/ai_workloads/leader-worker-set-operator)
- [Govern LLM access with Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/index)
- [Managing observability](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai)
- [Install Connectivity Link (Red Hat Connectivity Link 1.4)](https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html-single/install_connectivity_link/index)
- [OpenShift Container Platform Operators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/operators/index)

## Setup Steps

### 00 - LeaderWorkerSet Operator

Installs the LeaderWorkerSet operator used for multi-node distributed workloads.

**Documentation:** [Installing the Leader Worker Set Operator](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/ai_workloads/leader-worker-set-operator#installing-the-leader-worker-set-operator)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/00-leaderworkerset-operator
```

### 01 - LeaderWorkerSet Instance

Creates the LeaderWorkerSetOperator instance that manages the LeaderWorkerSet components on the cluster.

**Documentation:** [Installing the Leader Worker Set Operator](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/ai_workloads/leader-worker-set-operator#installing-the-leader-worker-set-operator) (create the `LeaderWorkerSetOperator` custom resource)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/01-leaderworkerset-instance
```

### 02 - JobSet Operator

Installs the JobSet operator used to manage distributed training jobs with KubeFlow Training Operator.

**Documentation:** [Installing distributed workloads components](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/installing_and_uninstalling_openshift_ai_self-managed/installing-the-distributed-workloads-components_install)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/02-jobset-operator
```

### 03 - OpenTelemetry Operator

Installs the Red Hat build of OpenTelemetry operator for collecting and exporting telemetry data.

**Documentation:** [Enabling the observability stack](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#enabling-the-observability-stack) (prerequisite operator), [Exporting metrics to external observability tools](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#exporting-metrics-to-external-observability-tools), [Red Hat build of OpenTelemetry](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/red_hat_build_of_opentelemetry/index)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/03-opentelemetry-operator
```

### 04 - Tempo Operator

Installs the Tempo operator for distributed tracing support.

**Documentation:** [Enabling the observability stack](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#enabling-the-observability-stack) (prerequisite operator), [Viewing traces in external tracing platforms](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#viewing-traces-in-external-tracing-platforms), [Distributed tracing](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/distributed_tracing/index)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/04-tempo-operator
```

### 05 - Cluster Observability Operator

Installs the Cluster Observability operator used by OpenShift AI observability features.

**Documentation:** [Enabling the observability stack](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#enabling-the-observability-stack) (prerequisite operator), [Accessing built-in alerts](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai#accessing-built-in-alerts), [Cluster Observability Operator](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/cluster_observability_operator/index)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/05-cluster-observability-operator
```

### 06 - Connectivity Link Operator

Installs the Red Hat Connectivity Link (Kuadrant) operator for API gateway and authorization capabilities.

**Documentation:** [Install Connectivity Link from the CLI](https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html-single/install_connectivity_link/index#install-connectivity-link-on-openshift-container-platform-from-the-cli), [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/06-connectivity-link-operator
```

### 07 - Optional Connectivity Link Console Plugin

Enables the Connectivity Link console plugin in the OpenShift console.

**Documentation:** [Enable the dynamic plugin for the OpenShift web console](https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html-single/install_connectivity_link/index#enable-the-dynamic-plugin-for-the-openshift-container-platform-web-console), [OpenShift Container Platform Operators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/operators/administrator-tasks)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/07-optional-connectivity-link-console-plugin
```

### 08 - Connectivity Link Kuadrant

Creates the Kuadrant instance that configures Connectivity Link on the cluster.

**Documentation:** [Install Connectivity Link from the CLI](https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html-single/install_connectivity_link/index#install-connectivity-link-on-openshift-container-platform-from-the-cli) (create the `Kuadrant` custom resource), [Govern LLM access with Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/index)

```bash
oc apply -k configs/03-rhoai-operator-dependencies/08-connectivity-link-kuadrant
```

### 09 - Connectivity Link TLS Setup

Configures TLS for Authorino using the OpenShift service serving certificate.

**Documentation:** [Configure TLS for MaaS](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html-single/govern_llm_access_with_models-as-a-service/index#configure-tls-for-maas_maas-deploy)

```bash
./configs/03-rhoai-operator-dependencies/09-connectivity-link-tls-setup.sh
```

## Additional Steps

Since we are pinning the Cluster Observability Operator to 1.4.0 with a manual install, you will need to approve the install plan for the operator in the OpenShift Web Console.
