# S3 backend
terraform {
    backend "s3" {
#  blanking/commenting this out to force an edit on new branches. Everyone is welcome to use the bucket but key MUST be changed for every deploy.
    bucket = "oss-testing-env"
    key    = "testing/tfstate"        # <-- CHANGE ME!!
    region = "eu-west-1"
    }
}

module "infra" {
    source = "./terraform"

    aws_account = var.aws_account
    aws_region = var.aws_region
    aws_key = var.aws_key
    aws_secret = var.aws_secret
    spinnaker_github_org = var.spinnaker_github_org
    spinnaker_github_repo = var.spinnaker_github_repo
    github_pat = var.github_pat
    cluster-version = var.cluster-version
    eks_node_type = var.eks_node_type
    eks_node_count = var.eks_node_count
    eks_asg_max_size = var.eks_asg_max_size
    db_instance_type = var.db_instance_type
    route53_primary_zone_id = var.route53_primary_zone_id
    domain_name = var.domain_name
    timezone = var.timezone
}