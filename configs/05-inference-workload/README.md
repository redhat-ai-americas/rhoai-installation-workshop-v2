# Inference Workload

Deploys a sample LLM inference service and configures Models-as-a-Service (MaaS) access for workshop participants.

## Objectives

- Deploy `meta-llama/llama-3.2-1b-instruct` via `LLMInferenceService`
- Publish the model to MaaS with subscription and authorization policies
- Validate chat completions through the MaaS gateway

## Rationale

Demonstrates end-to-end governed model access: model server, MaaS gateway auth (Kuadrant/Authorino), API keys, and rate limits.

## Takeaways

- MaaS requires healthy gateway AuthPolicies and database connection (see section 04)
- Stop the inference service after testing to release GPUs for other workshop sections (for example Kueue)
- Use `admin` or a cluster-admin user for MaaS token management; `dev` needs appropriate RBAC for namespace listing

## Documentation

- [Red Hat OpenShift AI Self-Managed 3.4 documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4)
- [Deploy models using Distributed Inference with llm-d](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/index)
- [Govern LLM access with Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/index)
- [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

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

**Validation:**

```bash
oc get llminferenceservice -n model-server
oc get maasmodelref -n model-server
```

### 02 - MaaS Subscription

Creates a demo MaaS subscription and authorization policy that grants authenticated users access to the model with token rate limits.

**Documentation:** [Deploy and manage Models-as-a-Service](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas)

```bash
oc apply -k configs/05-inference-workload/02-maas-subscription
```

**Validation:**

```bash
oc get maassubscription,maasauthpolicy -n models-as-a-service
```

### 03 - Stop Workload

Stops the deployed LLM inference service to free GPU resources after testing.

```bash
./configs/05-inference-workload/03-stop-workload/stop-workload.sh
```

## Additional Steps

Provision an API key from the OpenShift AI dashboard (**MaaS** > **Tokens**) or the MaaS API. Stop the model server when finished so GPUs are available for [08 - Kueue Workload](configs/08-kueue-workload/README.md).

### MaaS Endpoint Examples

```bash
MAAS_TOKEN="sk-oai-<token>"
MAAS_ROUTE="https://$(oc get route maas-gateway-route -n openshift-ingress -o jsonpath='{.spec.host}')"

curl "${MAAS_ROUTE}/model-server/llama-3-2-1b-instruct/v1/models" \
  --header "Authorization: Bearer ${MAAS_TOKEN}"

curl -X POST --location "${MAAS_ROUTE}/model-server/llama-3-2-1b-instruct/v1/chat/completions" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer ${MAAS_TOKEN}" \
  --data '{
    "model": "meta-llama/llama-3.2-1b-instruct",
    "messages": [
        {
            "role": "user",
            "content": "Who founded Red Hat?"
        }
    ],
    "temperature": 0.7,
    "max_tokens": 100
  }'
  


curl "${MAAS_ROUTE}/v1/models" \
  --header "Authorization: Bearer ${MAAS_TOKEN}"

curl -X POST --location "${MAAS_ROUTE}/v1/chat/completions" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer ${MAAS_TOKEN}" \
  --data '{
    "model": "publishers/model-server/models/meta-llama/llama-3.2-1b-instruct",
    "messages": [
        {
            "role": "user",
            "content": "Give me a brief history of Linux?"
        }
    ],
    "temperature": 0.7,
    "max_tokens": 1000
  }'
```
