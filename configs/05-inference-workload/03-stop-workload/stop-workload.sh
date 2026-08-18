#!/bin/bash
set -e

NAMESPACE=model-server
LLM_INFERENCE_SERVICE=llama-3-2-1b-instruct

echo "Stopping LLMInferenceService/${LLM_INFERENCE_SERVICE} in namespace ${NAMESPACE}"
oc annotate "llminferenceservice/${LLM_INFERENCE_SERVICE}" \
  -n "${NAMESPACE}" \
  serving.kserve.io/stop=true \
  --overwrite
