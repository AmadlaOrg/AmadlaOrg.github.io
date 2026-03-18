# Infrastructure/Cloud/Kubernetes/EKS

| Field | Value |
|-------|-------|
| **Purpose** | AWS EKS cluster configuration — VPC config, managed add-ons, IAM role, Fargate profiles |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Kubernetes/AWS/EKS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/kubernetes/eks@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Kubernetes](infrastructure-cloud-kubernetes.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `cluster_name` | string | EKS cluster name |
| `vpc_config` | object | VPC configuration (`subnet_ids[]`, `security_group_ids[]`, `endpoint_public_access`, `endpoint_private_access`) |
| `addons` | array of objects | EKS managed add-ons (`name`, `version`) |
| `addons[].name` | string | Add-on name (`vpc-cni`, `coredns`, `kube-proxy`, `ebs-csi-driver`) |
| `iam_role_arn` | string | IAM role ARN for the cluster |
| `fargate_profiles` | array of objects | Fargate profiles for serverless pod execution (`name`, `selectors[]`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/kubernetes/eks@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/kubernetes@v1.0.0
_body:
  cluster_name: prod-cluster
  vpc_config:
    subnet_ids:
      - subnet-abc123
      - subnet-def456
    security_group_ids:
      - sg-eks-cluster
    endpoint_public_access: false
    endpoint_private_access: true
  addons:
    - name: vpc-cni
    - name: coredns
    - name: ebs-csi-driver
  iam_role_arn: arn:aws:iam::123456789012:role/eks-cluster-role
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Kubernetes/EKS |
|------|------------------------------------------------|
| raise | Provisions EKS clusters via raise-aws plugin |
