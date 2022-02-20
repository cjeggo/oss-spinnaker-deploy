variable "cluster-version" {
    type = string
    description = "EKS Cluster version"
}

variable "eks_node_type" {
    type = string
    description = "EC2 instance type to use for EKS nodes"
}

variable "eks_node_count" {
    type = number
    description = "Worker node ASG desired capacity"
}

variable "eks_asg_max_size" {
    type = number
    description = "Worker node ASG max size"
}

variable "db_instance_type" {
    type = string
    description = "RDS instance type"
}

variable "route53_primary_zone_id" {
    type = string
    description = "Route 53 zone ID to create A records in"
}

variable "domain_name" {
    type = string
    description = "Domain name"
}

variable "aws_account" {
    type     = string
    description = "AWS account"
}

variable "aws_region" {
    type     = string
    description = "AWS region"
}

# variable "customer_name" {
#     type     = string
#     description = "Customer account name"
# }

variable "aws_key" {
    type = string
}

variable "aws_secret" {
    type = string
}

variable "spinnaker_github_org" {
    type = string
    description = "Repo to inject into Service Manifiest for dinghy etc"
}

variable "spinnaker_github_repo" {
    type = string
    description = "Repo to inject into Service Manifiest for dinghy etc"
}

variable "github_pat" {
    type = string
    description = "GitHub PAT for spinnaker access. Add as TF_VAR env"
}

variable "timezone" {}
