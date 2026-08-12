# Inference Workload

This section deploys a sample LLM inference workload and configures Models as a Service access for workshop participants.

## Setup Steps

### 00 - Model Server Namespace

Creates the `model-server` namespace with labels required for the OpenShift AI dashboard and MaaS gateway access.

```bash
oc apply -k configs/05-inference-workload/00-model-server-namespace
```

### 01 - Model Server

Deploys the Red Hat AI `gpt-oss-20b` LLMInferenceService and publishes it to Models as a Service.

```bash
oc apply -k configs/05-inference-workload/01-model-server
```

### 02 - MaaS Subscription

Creates a demo MaaS subscription and authorization policy that grants authenticated users access to the model with token rate limits.

```bash
oc apply -k configs/05-inference-workload/02-maas-subscription
```
