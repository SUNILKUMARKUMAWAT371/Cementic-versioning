# Cementic-versioning
Here's we add bash script that we can use in a GitHub Actions workflow to handle semantic versioning. This script will prompt the user to choose between a major, minor, or patch version upgrade.

# Workflow Explanation
Trigger: This workflow is triggered manually using workflow_dispatch, allowing you to choose when to bump the version.

Steps:

The repository is checked out.
Node.js is set up.
Dependencies are installed.
The version-bump.sh script is executed, prompting the user to choose between a major, minor, or patch version bump.
This setup ensures that every time you run the workflow, it will ask you for the type of version bump you'd like to apply.



## Helper Function

### `getEnvironmentName(branch)`

-   Determines the environment based on the Git branch:

    | Branch                       | Environment |
    |------------------------------|-------------|
    | `origin/feat/nonBureauOffers` | `staging`   |
    | `origin/feat/appTypes`       | `preprod`   |
    | `origin/release/prod`        | `prod`      |

## Usage




# Helm Chart Deployment & GCP NEG Integration Guide

This guide explains how to deploy and upgrade Helm charts for the nginx-ingress controller, configure GCP Zonal Network Endpoint Groups (NEGs), and properly set up firewall rules and load balancer integration.

## 🚀 Deployment & Upgrade using Helm

To deploy or upgrade the nginx-ingress Helm chart, use the following command:

```bash
helm upgrade --install ingress-nginx ./ --namespace ingress --create-namespace
```

This command installs or upgrades the ingress-nginx release from the local chart (./) into the ingress namespace. If the namespace doesn't exist, it will be created automatically.

### ⚙️ Configuration for GCP NEG (Zonal Network Endpoint Groups)

To automatically create and configure NEGs for the nginx-ingress controller service:

#### Edit values.yaml File:

Locate the values.yaml file in your Helm chart directory.
Go to line number 441 (or find the section where the controller service is defined).
Add or modify annotations under the service configuration to enable NEG creation.
Example Annotations:

```yaml
controller:
  service:
    annotations:
      cloud.google.com/neg: '{"exposed_ports": {"80":{"name": "gke-neg"}}}'
```

These annotations inform GKE to create a standalone NEG for the Ingress controller, enabling fine-grained traffic control at the load balancer level.

### 🔒 Firewall Configuration for Load Balancer Health Checks
After deploying and setting up NEGs:

#### Enable Health Check Ports:

GCP load balancers perform health checks on backend services using NEGs.
Ensure that the VPC firewall rules allow ingress traffic on the health check port (usually port 10256 or similar) from the GCP health check IP ranges.
Without this, the NEG will show as unhealthy, and traffic will not be routed to your GKE cluster.

Example Firewall Rule Setup:

```bash
gcloud compute firewall-rules create allow-health-check \
    --network default \
    --action allow \
    --direction ingress \
    --source-ranges 130.211.0.0/22,35.191.0.0/16 \
    --target-tags your-gke-node-tag \
    --ports 10256 \
    --protocol tcp
```

### ✅ Traffic Routing via Load Balancer
Once the NEG is healthy:

GCP Load Balancer will successfully route traffic to the NEG, which in turn targets the GKE nginx-ingress controller.
The controller will then distribute traffic to services defined in your ingress resources.
This setup ensures high availability, scalability, and better traffic observability.

## 📚 Official GCP Documentation
Refer to the following links for detailed official documentation from Google Cloud:

```https://cloud.google.com/kubernetes-engine/docs/how-to/standalone-neg
https://cloud.google.com/kubernetes-engine/docs/concepts/service-load-balancer-parameters
```

## 📌 Notes
Make sure your GKE nodes have the appropriate IAM roles and tags for NEG and Load Balancer integration.

Always validate your configuration after Helm install/upgrade using:

```bash
kubectl describe svc ingress-nginx-controller -n ingress
```
