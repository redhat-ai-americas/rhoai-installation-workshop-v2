# Kueue Workload

Demonstrates GPU quota management with Kueue on Red Hat OpenShift AI. Two teams share a cohort and borrow unused GPU quota while running workbenches and inference workloads.


## Objectives

- Configure Kueue `ResourceFlavor`, `ClusterQueue`, and `LocalQueue` for GPU scheduling
- Demonstrate quota borrowing between two team namespaces
- Run GPU workbenches and `LLMInferenceService` workloads through Kueue queues

## Rationale

Distributed workloads let you use larger datasets and more complex models, submit jobs when resources are available, and experiment faster. Kueue manages quotas and admission for those workloads.

## Takeaways

- Users submit jobs to a `LocalQueue`; Kueue routes them to a `ClusterQueue` that holds cluster-wide quotas
- `ResourceFlavor` describes heterogeneous resources (for example GPU node labels and tolerations)
- RHOAI supports a single cluster queue per cluster in homogeneous-GPU scenarios; adjust quota values for your node capacity
- The distributed workload stack is **Kueue + Ray + Training Operator**; Kueue operator is installed in section 03

Stop the sample inference service from [05 - Inference Workload](configs/05-inference-workload/README.md) before running GPU-heavy Kueue demos so GPUs are available for team queues.

## Documentation

- [Managing workloads with Kueue](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-workloads-with-kueue_managing-rhoai)
- [Managing distributed workloads](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-distributed-workloads_managing-rhoai)
- [Working with hardware profiles](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/working_with_accelerators/working-with-hardware-profiles_accelerators)
- [Cluster Queue (Kueue)](https://kueue.sigs.k8s.io/docs/concepts/cluster_queue/)
- [Kueue concepts](https://kueue.sigs.k8s.io/docs/concepts/)

## Setup Steps

### 00 - Kueue Setup

Creates the cluster-scoped `nvidia-gpu` ResourceFlavor with GPU node tolerations.

**Documentation:** [Managing distributed workloads](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-distributed-workloads_managing-rhoai)

```bash
oc apply -k configs/08-kueue-workload/00-kueue-setup
```

**Validation:**

```bash
oc get pods -n openshift-kueue-operator
oc get resourceflavor
```

### 01 - Team A Setup

Creates `team-a-kueue-example` namespace, `ClusterQueue`, `LocalQueue`, hardware profile, and `edit` RBAC for `dev`. Team A receives nominal quota for one GPU and may borrow from the shared `gpu-cohort`.

**Documentation:** [Configuring workload management with Kueue](https://docs.redhat.com/en/
documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/
managing-workloads-with-kueue_managing-rhoai#configuring-workload-management-with-kueue_managing-rho
ai)

```bash
oc apply -k configs/08-kueue-workload/01-team-a-setup
```

### 02 - Team B Setup

Creates `team-b-kueue-example` with the same cohort for cross-team quota borrowing.

```bash
oc apply -k configs/08-kueue-workload/02-team-b-setup
```

**Validation:**

```bash
oc get clusterqueue,localqueue -A
```

### 03 - Team A Workload

Deploys a queued `LLMInferenceService` (`llama-3.2-1b-instruct` with two replicas) and a `MaaSModelRef`.

**Documentation:** [Deploying models using Distributed Inference with llm-d](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/deploying-models-using-distributed-inference_distributed-inference)

```bash
oc apply -k configs/08-kueue-workload/03-team-a-workload
```

**Validation:**

```bash
oc get workloads -n team-a-kueue-example
oc get llminferenceservice -n team-a-kueue-example
oc get clusterqueue
oc get localqueue -n team-a-kueue-example
```

### 04 - Team B Workload

Deploys a GPU workbench (`preemption-example` Notebook) scheduled through the Team B Kueue queue.

```bash
oc apply -k configs/08-kueue-workload/04-team-b-workload
```

**Validation:**

```bash
oc get notebook -n team-b-kueue-example
oc get workloads -n team-b-kueue-example
```

Monitor queue admission as workloads compete for limited GPU quota:

```bash
oc get localqueue -A
```
