# NVIDIA GPU Workload

This section deploys sample GPU workloads to verify that NVIDIA GPUs are available and schedulable on the cluster.

## Documentation

- [NVIDIA GPU Operator documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)
- [OpenShift Container Platform hardware accelerators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hardware_accelerators/index)
- [AI workloads on OpenShift Container Platform](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/ai_workloads/index)

## Setup Steps

### 00 - GPU Test Namespace

Creates a sandbox namespace for GPU validation workloads.

**Documentation:** [Managing projects and namespaces](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/building_applications/projects)

```bash
oc apply -k configs/02-nvidia-gpu-workload/00-gpu-test-namespace
```

### 01 - NVIDIA GPU Workload

Runs a CUDA vector-add sample pod that requests one NVIDIA GPU.

**Documentation:** [NVIDIA GPU Operator on OpenShift](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/install-gpu-ocp.html)

```bash
oc apply -k configs/02-nvidia-gpu-workload/01-nvidia-gpu-workload
```

### 02 - NVIDIA GPU nvidia-smi

Runs an `nvidia-smi` pod to display GPU device information from a scheduled workload.

**Documentation:** [Hardware accelerators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hardware_accelerators/index)

```bash
oc apply -k configs/02-nvidia-gpu-workload/02-nvidia-gpu-nvidia-smi
```

## Additional Steps

Review the pod logs for the deployed workloads.
