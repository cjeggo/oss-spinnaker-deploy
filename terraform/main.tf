### Providers ###
provider "aws" {
    region = var.aws_region
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "kubectl" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
}

### Random number gen when unique value is needed ###
resource "random_integer" "instance_id" {
    min = 1
    max = 5000
}

### Data & locals ###
# Use this to grab region specific AMI for DB setup bastion
data "aws_ami" "amazon-2" {
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
    owners = ["amazon"]
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

# Used to grab the ASG name created by the EKS module to then use for ASG policies
data "aws_autoscaling_groups" "asg" {
    filter {
        name = "tag:cluster_name"
        values = ["oss"]
    }
    depends_on = [
        module.eks.worker_groups
    ]
}

# Operator 1.4
# module "operator_crds" {
#     source = "./operator_crd"
# }

# module "operator_cluster" {
#     source = "./operator_cluster"
# }
