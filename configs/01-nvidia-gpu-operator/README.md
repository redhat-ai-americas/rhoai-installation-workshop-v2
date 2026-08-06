# NVIDIA GPU Operator

This section installs and configures the NVIDIA GPU Operator stack so the cluster can discover GPUs and schedule GPU workloads.

## Setup Steps

### 00 - NFD Operator

Installs the Node Feature Discovery (NFD) operator, which labels nodes based on hardware capabilities such as GPUs.

```bash
oc apply -k configs/01-nvidia-gpu-operator/00-nfd-operator
```

### 01 - NVIDIA GPU Operator

Installs the NVIDIA GPU Operator, which manages NVIDIA drivers, device plugins, and related GPU components on the cluster.

```bash
oc apply -k configs/01-nvidia-gpu-operator/01-nvidia-gpu-operator
```

### 02 - NFD Instance

Creates a NodeFeatureDiscovery instance so NFD begins labeling nodes with detected hardware features.

```bash
oc apply -k configs/01-nvidia-gpu-operator/02-nfd-instance
```

### 03 - NVIDIA GPU Instance

Deploys the NVIDIA ClusterPolicy that configures drivers, device plugins, and monitoring components for GPU nodes.

```bash
oc apply -k configs/01-nvidia-gpu-operator/03-nvidia-gpu-instance
```

### 04 - Optional NVIDIA Monitoring Dashboard

Adds a DCGM exporter Grafana dashboard to the OpenShift console for viewing GPU metrics.

```bash
oc apply -k configs/01-nvidia-gpu-operator/04-optional-nvidia-monitoring-dashboard
```

### 05 - Optional NVIDIA Console Plugin

Enables the NVIDIA GPU console plugin so GPU status and metrics are visible in the OpenShift console.

```bash
oc apply -k configs/01-nvidia-gpu-operator/05-optional-nvidia-console-plugin
```
