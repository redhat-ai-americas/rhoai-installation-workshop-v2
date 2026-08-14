# Cluster Setup

This section is designed to help setup some initial items needed on our cluster.

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

**Documentation:** [Configuring an htpasswd identity provider](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/configuring-identity-providers#configuring-an-htpasswd-identity-provider)

```bash
./configs/00-cluster-setup/01-generate-htpasswd.sh
```

### 02 - User Auth

Configures an HTPasswd identity provider with local `admin` and `dev` users for signing into the cluster.

**Documentation:** [Understanding identity provider configuration](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/understanding-identity-provider)

```bash
oc apply -k configs/00-cluster-setup/02-user-auth
```

### 03 - User RBAC

Grants cluster-admin access to the `admin` user and gives cluster-admin for `kube:admin` to help resolve some permissions issues with RHOAI.

**Documentation:** [Using RBAC to define and apply permissions](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/authentication_and_authorization/using-rbac)

```bash
oc apply -k configs/00-cluster-setup/03-user-rbac
```

### 04 - AWS GPU MachineSet

Creates a GPU MachineSet on AWS so the cluster can schedule GPU-backed workloads.

**Documentation:** [Adding a GPU node to an existing OpenShift Container Platform cluster](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/machine_management/managing-compute-machines-with-the-machine-api#adding-a-gpu-node-to-an-existing-openshift-container-platform-cluster)

```bash
oc apply -k configs/00-cluster-setup/04-aws-gpu-machineset
```

### 05 - End User Workload Monitoring

Enables OpenShift user workload monitoring so application metrics can be collected and viewed in the console.

**Documentation:** [User workload monitoring first steps](https://docs.redhat.com/en/documentation/monitoring_stack_for_red_hat_openshift/4.20/html/getting_started/user-workload-monitoring-first-steps)

```bash
oc apply -k configs/00-cluster-setup/05-enduser-workload-monitoring
```
