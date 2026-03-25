# Infrastructure/Cloud

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud infrastructure properties — provider, region, credentials, tags |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud@v1.0.0` |
| **Parent type** | [Infrastructure](infrastructure.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `provider` | string | Cloud provider name (e.g., `aws`, `gcp`, `azure`, `hetzner`, `digitalocean`) |
| `region` | string | Deployment region (e.g., `us-east-1`, `europe-west1`) |
| `credentials_secret` | string | Doorman secret reference for provider credentials |
| `account_id` | string | Provider account or project ID |
| `tags` | object | Default tags/labels applied to all resources |

**Required:** `provider`, `region`

These properties are inherited by all cloud service sub-types via `_extends`.

## Sub-types

| Sub-type | Purpose |
|----------|---------|
| [Cloud/Compute](infrastructure-cloud-compute.md) | Virtual machine instances (EC2, GCE, Azure VM, Hetzner, DigitalOcean) |
| [Cloud/Network](infrastructure-cloud-network.md) | Virtual private networks (AWS VPC, GCP VPC, Azure VNet) |
| [Cloud/DNS](infrastructure-cloud-dns.md) | Managed DNS zones and records (Route53, Cloud DNS, Azure DNS, Cloudflare) |
| [Cloud/CDN](infrastructure-cloud-cdn.md) | Content delivery networks (CloudFront, Cloudflare, Fastly) |
| [Cloud/ObjectStorage](infrastructure-cloud-object-storage.md) | Object storage buckets (S3, GCS, Azure Blob) |
| [Cloud/Database](infrastructure-cloud-database.md) | Managed databases (RDS, Cloud SQL, Azure Database) |
| [Cloud/Kubernetes](infrastructure-cloud-kubernetes.md) | Managed Kubernetes clusters (EKS, GKE, AKS) |
| [Cloud/LoadBalancer](infrastructure-cloud-load-balancer.md) | Load balancers (ALB, GCP Cloud LB, Azure LB) |
| [Cloud/Serverless](infrastructure-cloud-serverless.md) | Serverless functions (Lambda, Cloud Functions, Azure Functions) |
| [Cloud/Queue](infrastructure-cloud-queue.md) | Message queues (SQS, Pub/Sub, Service Bus) |
| [Cloud/IAM](infrastructure-cloud-iam.md) | Identity and access management (AWS IAM, GCP IAM, Azure Entra ID) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  provider: aws
  region: us-east-1
  credentials_secret: doorman://aws/prod-credentials
  account_id: "123456789012"
  tags:
    environment: production
    team: platform
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud |
|------|----------------------------------------|
| [raise](../tools/raise.md) | Provisions cloud resources via provider-specific plugins |
| [conduct](../tools/conduct.md) | Coordinates multi-cloud deployments |
