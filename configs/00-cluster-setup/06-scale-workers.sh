#!/bin/bash
set -e

NAMESPACE=openshift-machine-api
REPLICAS=2

scale_machineset() {
  local machineset=$1
  echo "Scaling machineset/${machineset} to ${REPLICAS} replicas"
  oc -n "${NAMESPACE}" scale "machineset/${machineset}" --replicas="${REPLICAS}"
}

GPU_MACHINESET=$(
  oc -n "${NAMESPACE}" get machinesets.machine.openshift.io \
    -l cluster-api/accelerator=nvidia-gpu \
    -o jsonpath='{.items[0].metadata.name}'
)

if [ -z "${GPU_MACHINESET}" ]; then
  echo "GPU MachineSet not found. Apply step 05-aws-gpu-machineset first."
  exit 1
fi

scale_machineset "${GPU_MACHINESET}"

WORKER_MACHINESET=""
for machineset in $(oc -n "${NAMESPACE}" get machinesets.machine.openshift.io -o name); do
  name="${machineset#*/}"
  if ! echo "${name}" | grep -q worker; then
    continue
  fi

  accelerator=$(
    oc -n "${NAMESPACE}" get "${machineset}" \
      -o jsonpath='{.metadata.labels.cluster-api/accelerator}'
  )

  if [ "${accelerator}" != "nvidia-gpu" ]; then
    WORKER_MACHINESET="${name}"
    break
  fi
done

if [ -z "${WORKER_MACHINESET}" ]; then
  echo "Non-GPU worker MachineSet not found."
  exit 1
fi

scale_machineset "${WORKER_MACHINESET}"
