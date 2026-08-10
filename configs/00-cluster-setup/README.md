# Cluster Setup

This section is designed to help setup some initial items needed on our cluster.

## Setup Steps

### 00 - Cluster Notification

Displays a workshop banner at the top of the OpenShift console so participants can quickly confirm they are on the correct cluster.

```bash
oc apply -k configs/00-cluster-setup/00-cluster-notification
```

### 01 - Generate HTPasswd

Creates a local `.htpasswd` file with `admin` and `dev` users for the HTPasswd identity provider.

```bash
./configs/00-cluster-setup/01-generate-htpasswd.sh
```

### 02 - User Auth

Configures an HTPasswd identity provider with local `admin` and `dev` users for signing into the cluster.

```bash
oc apply -k configs/00-cluster-setup/02-user-auth
```

### 03 - User RBAC

Grants cluster-admin access to the `admin` user and gives cluster-admin for `kube:admin` to help resolve some permissions issues with RHOAI.

```bash
oc apply -k configs/00-cluster-setup/03-user-rbac
```

### 04 - AWS GPU MachineSet

Creates a GPU MachineSet on AWS so the cluster can schedule GPU-backed workloads.

```bash
oc apply -k configs/00-cluster-setup/04-aws-gpu-machineset
```

### 05 - End User Workload Monitoring

Enables OpenShift user workload monitoring so application metrics can be collected and viewed in the console.

```bash
oc apply -k configs/00-cluster-setup/05-enduser-workload-monitoring
```
