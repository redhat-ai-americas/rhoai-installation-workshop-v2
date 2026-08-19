# Cluster Setup

Initial cluster configuration for the workshop: authentication, RBAC, monitoring, and GPU worker capacity.

## Documentation

- [OpenShift Container Platform 4.20 documentation](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20)
- [Postinstallation configuration](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/postinstallation_configuration/index)
- [Authentication and authorization](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/index)

## Setup Steps

### 00 - Cluster Notification

Displays a workshop banner at the top of the OpenShift console so participants can quickly confirm they are on the correct cluster.

**Documentation:** [Customizing the web console](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/web_console/index)

```bash
oc apply -k configs/00-cluster-setup/00-cluster-notification
```

### 01 - Generate HTPasswd

Creates a local `.htpasswd` file with `admin` and `dev` users for the HTPasswd identity provider.

**Objectives:** Create credentials for workshop users before configuring the OAuth identity provider.

**Takeaways:** Customers care about RBAC and IdP integration; `kubeadmin` should not be used in production. The `User` object for an HTPasswd user is created on first login.

**Documentation:** [Configuring an htpasswd identity provider](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/configuring-identity-providers#configuring-an-htpasswd-identity-provider)

```bash
./configs/00-cluster-setup/01-generate-htpasswd/generate-htpasswd.sh
```

**Validation:** Confirm `configs/00-cluster-setup/02-user-auth/.htpasswd` exists after running the script.

### 02 - User Auth

Configures an HTPasswd identity provider with local `admin` and `dev` users for signing into the cluster.

**Documentation:** [Understanding identity provider configuration](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/understanding-identity-provider)

```bash
oc apply -k configs/00-cluster-setup/02-user-auth
```

**Validation:**

```bash
oc get secret htpasswd-local -n openshift-config
oc get oauth cluster -o yaml | grep -A5 htpasswd
```

Wait for the `authentication` ClusterOperator to cycle and return to Available after applying OAuth configuration.

### 03 - User RBAC

Grants `cluster-admin` to the `cluster-admins` group (member: `admin`) and gives cluster-admin for `kube:admin` to help resolve some permissions issues with RHOAI if you do still choose to use kube:admin.

**Documentation:** [Using RBAC to define and apply permissions](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/using-rbac)

```bash
oc apply -k configs/00-cluster-setup/03-user-rbac
```

**Validation:** Log in as `admin` and confirm cluster-admin access. Complete remaining steps as `admin`, not `kubeadmin`.

### 04 - End User Workload Monitoring

Enables OpenShift user workload monitoring so application metrics can be collected and viewed in the console.

**Documentation:** [User workload monitoring first steps](https://docs.redhat.com/en/documentation/monitoring_stack_for_red_hat_openshift/4.20/html/getting_started/user-workload-monitoring-first-steps)

```bash
oc apply -k configs/00-cluster-setup/04-enduser-workload-monitoring
```

### 05 - AWS GPU MachineSet

Creates a GPU MachineSet on AWS so the cluster can schedule GPU-backed workloads.

**Objectives:** Copy and modify an existing compute MachineSet to add GPU-enabled nodes on AWS.

**Rationale:** The RHOAI operator does not configure GPUs; nodes must exist before the NVIDIA GPU Operator can install drivers and advertise `nvidia.com/gpu`.

**Takeaways:** Understand nodes vs. machines vs. MachineSets. After GPU nodes exist, create RHOAI hardware profiles for GPU workloads. NVIDIA, Intel Gaudi, and AMD are supported accelerators in RHOAI.

**Documentation:** [Adding a GPU node to an existing OpenShift Container Platform cluster](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/machine_management/managing-compute-machines-with-the-machine-api#adding-a-gpu-node-to-an-existing-openshift-container-platform-cluster)

```bash
oc apply -k configs/00-cluster-setup/05-aws-gpu-machineset
```

**Validation:**

```bash
oc get machinesets -n openshift-machine-api
oc get machines -n openshift-machine-api -w
```

Wait until the GPU MachineSet shows `READY` and the Machine reaches `Running`.

### 06 - Scale Workers

Scales the GPU worker MachineSet and the non-GPU worker MachineSet to two nodes each.

**Objectives:** Provide enough non-GPU capacity for OpenShift AI infrastructure (pipeline servers, databases, object storage) alongside GPU workers.

**Rationale:** A single GPU node is often insufficient for RHOAI platform components and user workloads. Scaling non-GPU workers prevents scheduling failures for control-plane-adjacent services.

**Documentation:** [Managing compute machines with the Machine API](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/machine_management/managing-compute-machines-with-the-machine-api)

```bash
./configs/00-cluster-setup/06-scale-workers/scale-workers.sh
```

**Validation:**

```bash
oc get machinesets -n openshift-machine-api
oc get nodes
```

You can also scale MachineSets from the OpenShift console under **Compute** > **MachineSets**.
