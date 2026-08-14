# NVIDIA GPU Operator

This section installs and configures the NVIDIA GPU Operator stack so the cluster can discover GPUs and schedule GPU workloads.

## Documentation

- [NVIDIA GPU Operator documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html)
- [NVIDIA GPU Operator on Red Hat OpenShift Container Platform](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/install-gpu-ocp.html)
- [OpenShift Container Platform hardware accelerators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hardware_accelerators/index)

## Setup Steps

### 00 - NFD Operator

Installs the Node Feature Discovery (NFD) operator, which labels nodes based on hardware capabilities such as GPUs.

**Documentation:** [Node Feature Discovery in OpenShift hardware accelerators](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/hardware_accelerators/index)

```bash
oc apply -k configs/01-nvidia-gpu-operator/00-nfd-operator
```

### 01 - NVIDIA GPU Operator

Installs the NVIDIA GPU Operator, which manages NVIDIA drivers, device plugins, and related GPU components on the cluster.

**Documentation:** [Installing the NVIDIA GPU Operator on OpenShift](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/install-gpu-ocp.html)

```bash
oc apply -k configs/01-nvidia-gpu-operator/01-nvidia-gpu-operator
```

### 02 - NFD Instance

Creates a NodeFeatureDiscovery instance so NFD begins labeling nodes with detected hardware features.

**Documentation:** [Node Feature Discovery Operator](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/specialized_hardware_and_driver_enablement/psap-node-feature-discovery-operator)

```bash
oc apply -k configs/01-nvidia-gpu-operator/02-nfd-instance
```

### 03 - NVIDIA GPU Instance

Deploys the NVIDIA ClusterPolicy that configures drivers, device plugins, and monitoring components for GPU nodes.

**Documentation:** [Create the ClusterPolicy instance on OpenShift](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/install-gpu-ocp.html#create-the-clusterpolicy-instance)

```bash
oc apply -k configs/01-nvidia-gpu-operator/03-nvidia-gpu-instance
```

### 04 - Optional NVIDIA Monitoring Dashboard

Adds a DCGM exporter Grafana dashboard to the OpenShift console for viewing GPU metrics.

**Documentation:** [GPU Operator monitoring on OpenShift](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/install-gpu-ocp.html)

```bash
oc apply -k configs/01-nvidia-gpu-operator/04-optional-nvidia-monitoring-dashboard
```

### 05 - Optional NVIDIA Console Plugin

Enables the NVIDIA GPU console plugin so GPU status and metrics are visible in the OpenShift console.

**Documentation:** [NVIDIA GPU Operator on OpenShift](https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/index.html)

```bash
oc apply -k configs/01-nvidia-gpu-operator/05-optional-nvidia-console-plugin
```

## Additional Steps

At this point in time, the GPU node should hopefully be up and running.

Using the OpenShift Web Console, view the pods on the GPU node and track the status of the NVIDIA pods.
