# Kueue Workload

This section demonstrates GPU quota management with Kueue on Red Hat OpenShift AI. Two teams share a cohort and borrow unused GPU quota from each other while running GPU workbenches and inference workloads.

## Prerequisites

Complete these workshop sections first:

- [03 - RHOAI Operator Dependencies](configs/03-rhoai-operator-dependencies/README.md) (Kueue operator)
- [04 - RHOAI Setup](configs/04-rhoai-setup/README.md) (OpenShift AI dashboard, MaaS gateway, MLflow)
- [00 - Cluster Setup](configs/00-cluster-setup/README.md) step 06 (GPU worker nodes scaled)

Stop the sample inference service from [05 - Inference Workload](configs/05-inference-workload/README.md) before running GPU-heavy Kueue demos so GPUs are available for team queues.

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Managing workloads with Kueue](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-workloads-with-kueue_managing-rhoai)
- [Managing distributed workloads](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-distributed-workloads_managing-rhoai)
- [Working with hardware profiles](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_accelerators/working-with-hardware-profiles_accelerators)
- [Cluster Queue (Kueue)](https://kueue.sigs.k8s.io/docs/concepts/cluster_queue/)

## Setup Steps

### 00 - Kueue Setup

Creates the cluster-scoped `nvidia-gpu` ResourceFlavor with GPU node tolerations.

**Documentation:** [Managing distributed workloads](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-distributed-workloads_managing-rhoai)

```bash
oc apply -k configs/08-kueue-workload/00-kueue-setup
```

### 01 - Team A Setup

Creates the `team-a-kueue-example` namespace, `ClusterQueue`, `LocalQueue`, and team-scoped hardware profile. Team A receives nominal quota for one GPU and may borrow one additional GPU from the shared `gpu-cohort`.

**Documentation:** [Configuring workload management with Kueue](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-workloads-with-kueue_managing-rhoai#configuring-workload-management-with-kueue_managing-rhoai)

```bash
oc apply -k configs/08-kueue-workload/01-team-a-setup
```

### 02 - Team B Setup

Creates the `team-b-kueue-example` namespace, `ClusterQueue`, `LocalQueue`, and hardware profile. Team B joins the same `gpu-cohort` as Team A for cross-team quota borrowing.

```bash
oc apply -k configs/08-kueue-workload/02-team-b-setup
```

### 03 - Team A Workload

Deploys a queued `LLMInferenceService` (`llama-3.2-1b-instruct` with two replicas) and publishes it to Models as a Service through a `MaaSModelRef`.

**Documentation:** [Deploying models using Distributed Inference with llm-d](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/deploying-models-using-distributed-inference_distributed-inference)

```bash
oc apply -k configs/08-kueue-workload/03-team-a-workload
```

### 04 - Team B Workload

Deploys a GPU workbench (`preemption-example` Notebook) that schedules through the Team B Kueue queue.

```bash
oc apply -k configs/08-kueue-workload/04-team-b-workload
```
