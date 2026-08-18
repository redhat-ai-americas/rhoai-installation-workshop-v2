#!/bin/bash
set -e

NAMESPACE=openshift-machine-api
GPU_REPLICAS=2
WORKER_REPLICAS=2

scale_machineset() {
  local machineset=$1
  local replicas=$2
  echo "Scaling machineset/${machineset} to ${replicas} replicas"
  oc -n "${NAMESPACE}" scale "machineset/${machineset}" --replicas="${replicas}"
}

find_gpu_machineset() {
  local machineset accelerator gpu_node_label name

  for machineset in $(oc -n "${NAMESPACE}" get machinesets.machine.openshift.io -o name); do
    name="${machineset#*/}"

    accelerator=$(
      oc -n "${NAMESPACE}" get "${machineset}" \
        -o jsonpath='{.metadata.labels.cluster-api/accelerator}'
    )
    if [ "${accelerator}" = "nvidia-gpu" ]; then
      echo "${name}"
      return 0
    fi

    gpu_node_label=$(
      oc -n "${NAMESPACE}" get "${machineset}" \
        -o jsonpath='{.spec.template.metadata.labels.node-role\.kubernetes\.io/gpu}'
    )
    if [ -n "${gpu_node_label}" ]; then
      echo "${name}"
      return 0
    fi
  done

  for pattern in g4dn g4ad g5 p3 p4 p5; do
    name=$(
      oc -n "${NAMESPACE}" get machinesets.machine.openshift.io -o name | \
        grep "${pattern}" | head -n1 | sed 's/.*\///'
    )
    if [ -n "${name}" ]; then
      echo "${name}"
      return 0
    fi
  done

  return 1
}

GPU_MACHINESET="$(find_gpu_machineset || true)"

if [ -z "${GPU_MACHINESET}" ]; then
  echo "GPU MachineSet not found."
  echo "Apply step 05-aws-gpu-machineset first, then re-run this script."
  echo "Current MachineSets in ${NAMESPACE}:"
  oc -n "${NAMESPACE}" get machinesets.machine.openshift.io
  exit 1
fi

scale_machineset "${GPU_MACHINESET}" "${GPU_REPLICAS}"

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
  oc -n "${NAMESPACE}" get machinesets.machine.openshift.io
  exit 1
fi

scale_machineset "${WORKER_MACHINESET}" "${WORKER_REPLICAS}"
