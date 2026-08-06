# NVIDIA GPU Workload

This section deploys a sample GPU workload to verify that NVIDIA GPUs are available and schedulable on the cluster.

## Setup Steps

### 00 - NVIDIA GPU Workload

Creates a sandbox namespace and runs a CUDA vector-add sample pod that requests one NVIDIA GPU.

```bash
oc apply -k configs/02-nvidia-gpu-workload/00-nvidia-gpu-workload
```
