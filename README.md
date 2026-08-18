# RHOAI Installation Workshop

Manifests and step-by-step instructions for deploying Red Hat OpenShift AI (RHOAI) on OpenShift, from initial cluster preparation through GPU workloads, model serving, object storage, and data science pipelines.

Apply manifests from the repository root unless a section README specifies otherwise:

```bash
oc apply -k configs/<section>/<step>
```

## Cluster Recommendations

This workshop was built and testing using OpenShift 4.20.31+.

If using the Red Hat Demo Platform, the `AWS with OpenShift Open Environment` is the recommended catalog item.  Be sure to request the `m6a.4xlarge` Control Plane Instance Type.

## Documentation

Each workshop section README links to official product documentation for additional context. Primary references:

- [Red Hat OpenShift AI Self-Managed 3.4](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [OpenShift Container Platform 4.20](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20)
- [NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)

See [CONTRIBUTING.md](CONTRIBUTING.md) for repository conventions and validation requirements.

## Workshop Sections

The `configs/` directory is organized into numbered sections. Complete them in order; later sections depend on earlier ones.

### [00 - Cluster Setup](configs/00-cluster-setup/README.md)

**Objective:** Prepare the OpenShift cluster for the workshop—authentication, RBAC, GPU capacity, and monitoring—so participants can sign in and run AI workloads.

Configures a workshop banner, HTPasswd identity provider (`admin` / `dev` users), cluster-admin RBAC, an AWS GPU MachineSet, and user workload monitoring.

### [01 - NVIDIA GPU Operator](configs/01-nvidia-gpu-operator/README.md)

**Objective:** Install and configure the NVIDIA GPU Operator stack so the cluster discovers GPUs and can schedule GPU-backed pods.

Deploys Node Feature Discovery (NFD), the NVIDIA GPU Operator, ClusterPolicy, and optional GPU monitoring dashboards and console plugins.

### [02 - NVIDIA GPU Workload](configs/02-nvidia-gpu-workload/README.md)

**Objective:** Validate that GPUs are available and schedulable by running sample CUDA workloads on the cluster.

Creates a test namespace and deploys sample GPU pods to confirm the operator stack is working end to end.

### [03 - RHOAI Operator Dependencies](configs/03-rhoai-operator-dependencies/README.md)

**Objective:** Install operators and supporting configuration that Red Hat OpenShift AI depends on before the core RHOAI installation.

Installs LeaderWorkerSet, JobSet, Kueue, OpenTelemetry, Tempo, Cluster Observability, and Connectivity Link (Kuadrant) operators, plus TLS setup for Authorino.

### [04 - RHOAI Setup](configs/04-rhoai-setup/README.md)

**Objective:** Install and configure Red Hat OpenShift AI—the dashboard, DataScienceCluster, observability, inference and MaaS gateways, PostgreSQL, MLflow, hardware profiles, and dashboard customization.

This is the core OpenShift AI platform that later sections use for model serving and pipelines.

### [05 - Inference Workload](configs/05-inference-workload/README.md)

**Objective:** Deploy a sample LLM inference service and configure Models as a Service (MaaS) so workshop participants can call a model through authenticated API access.

Creates the model-server namespace, deploys a `meta-llama/llama-3.2-1b-instruct` LLMInferenceService, and sets up a demo MaaS subscription with authorization policies.

### [06 - ODF NooBaa](configs/06-odf-noobaa/README.md)

**Objective:** Provide S3-compatible object storage on the cluster for pipeline artifacts and other workloads using OpenShift Data Foundation and a standalone NooBaa instance.

Installs the ODF operator, optionally enables the ODF console plugin, and deploys a StorageCluster with NooBaa multi-cloud gateway.

### [07 - AI Pipelines](configs/07-ai-pipelines/README.md)

**Objective:** Configure Data Science Pipelines and run a sample Iris classification workflow using NooBaa object storage for pipeline artifacts.

Creates the pipeline namespace, deploys a DataSciencePipelinesApplication (DSPA) with MariaDB and an ObjectBucketClaim, and applies the Iris Kubeflow pipeline.

### [08 - Kueue Workload](configs/08-kueue-workload/README.md)

**Objective:** Demonstrate GPU quota sharing and borrowing between teams using Kueue queues, hardware profiles, and sample inference and workbench workloads.

Configures ResourceFlavors, per-team ClusterQueues in a shared cohort, and deploys Team A inference and Team B workbench workloads that compete for GPU capacity.
