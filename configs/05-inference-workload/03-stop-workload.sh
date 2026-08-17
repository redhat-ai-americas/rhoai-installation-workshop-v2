#!/bin/bash
set -e

NAMESPACE=model-server
LLM_INFERENCE_SERVICE=redhataigpt-oss-20b

echo "Stopping LLMInferenceService/${LLM_INFERENCE_SERVICE} in namespace ${NAMESPACE}"
oc annotate "llminferenceservice/${LLM_INFERENCE_SERVICE}" \
  -n "${NAMESPACE}" \
  serving.kserve.io/stop=true \
  --overwrite
