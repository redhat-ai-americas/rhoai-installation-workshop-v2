# Inference Workload

This section deploys a sample LLM inference workload and configures Models as a Service access for workshop participants.

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Deploy models using Distributed Inference with llm-d](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/index)
- [Govern LLM access with Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/index)
- [Configuring your model-serving platform](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/configuring_your_model-serving_platform/index)

## Setup Steps

### 00 - Model Server Namespace

Creates the `model-server` namespace with labels required for the OpenShift AI dashboard and MaaS gateway access.

**Documentation:** [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

```bash
oc apply -k configs/05-inference-workload/00-model-server-namespace
```

### 01 - Model Server

Deploys the `meta-llama/llama-3.2-1b-instruct` LLMInferenceService and publishes it to Models as a Service.

**Documentation:** [Deploying models by using Distributed Inference with llm-d](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/deploying-models-using-distributed-inference_distributed-inference)

```bash
oc apply -k configs/05-inference-workload/01-model-server
```

### 02 - MaaS Subscription

Creates a demo MaaS subscription and authorization policy that grants authenticated users access to the model with token rate limits.

**Documentation:** [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

```bash
oc apply -k configs/05-inference-workload/02-maas-subscription
```

### 03 - Stop Workload

Stops the deployed LLM inference service (`llama-3-2-1b-instruct`) by setting the KServe stop annotation on the `LLMInferenceService`.

```bash
./configs/05-inference-workload/03-stop-workload/stop-workload.sh
```

## Additional Steps

Dev user should now be able to provision an API key for the model server.  Be sure to stop the model server to free up the GPUs after testing.
