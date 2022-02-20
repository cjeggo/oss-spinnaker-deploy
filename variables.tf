# EKS Config
variable "cluster-version" {
    type = string
    default = "1.21"
    description = "EKS Cluster version"
}

variable "eks_node_type" {
    type = string
    default = "r5.large"
    description = "EC2 instance type to use for EKS nodes"
}

variable "eks_node_count" {
    default = 1
    type = number
    description = "Worker node ASG desired capacity"
}

variable "eks_asg_max_size" {
    default = 3
    type = number
    description = "Worker node ASG max size"
}

# Database config
variable "db_instance_type" {
    default = "db.t3.small"
    description = "Aurora instance type"
}

# Route53
variable "route53_primary_zone_id" {
    default = "Z0277253WQIZFHHI1E1M"
    description = "Route 53 zone ID to create A records in"
}

variable "domain_name" {
    default = "tse-armory.io"
    description = "Domain name"
}

# All of the below should be set as env vars and not hard coded here!!
# Github config for Artifacts, Dinghy etc.
variable "spinnaker_github_org" {
    type    = string
    default = "armory-io"
    description = "Repo to inject into Service Manifiest for dinghy etc"
}
variable "spinnaker_github_repo" {
    type     = string
    default = "training-env-examples"
    description = "Repo to inject into Service Manifest for dinghy etc"
}

# Customer name for tagging everything
# variable "customer_name" {
#     default = "oss"
#     type     = string
#     description = "Customer account name"
# }

variable "aws_region" {
    type     = string
    description = "AWS region"
}

variable "aws_account" {
    type     = string
    description = "AWS account"
}

variable "aws_key" {
    type = string
}

variable "aws_secret" {
    type = string
}

variable "github_pat" {
    type = string
    description = "GitHub PAT for spinnaker access. Add as TF_VAR env"
}

variable "timezone" {
    type    = map
    default = {
    # AMER
    "us-east-1" = "America/New_York"
    "us-east-2" = "America/New_York"
    "us-west-1" = "America/Los_Angeles"
    "us-west-2" = "America/Los_Angeles"
    "ca-central-1" = "America/Toronto"
    "sa-east-1" = "America/Sao_Paulo"

    # EMEA
    "eu-central-1" = "Europe/Berlin"
    "eu-west-1" = "Europe/Dublin"
    "eu-west-2" = "Europe/London"
    "eu-west-3" = "Europe/Paris"
    "eu-south-1" = "Europe/Rome"
    "eu-north-1" = "Europe/Stockholm"
    "af-south-1" = "Africa/Johannesburg"
    
    # APAC
    "me-south-1" = "Asia/Dubai"
    "ap-southeast-1" = "Asia/Singapore"
    "ap-southeast-2" = "Australia/Sydney"
    "ap-northeast-1" = "Asia/Tokyo"
    "ap-northeast-2" = "Asia/Seoul"
    "ap-south-1" = "Asia/Calcutta"
    }

    description = "TZ to map into autoscaling schedule"
}
