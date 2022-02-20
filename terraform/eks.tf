# EKS cluster
module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    version         = "17.24.0"
    cluster_name    = "oss-cluster"
    cluster_version = var.cluster-version
    subnets         = module.vpc.private_subnets
    worker_additional_security_group_ids = [aws_security_group.worker_node_sg.id]
    map_roles       = [{ groups = ["system:masters"]                       
                        rolearn = "arn:aws:iam::810711266228:role/okta-admin-role",
                        username = "{{EC2PrivateDNSName}}"
                        }]
    map_users       = [{"userarn": "arn:aws:iam::810711266228:user/jeggo-github-actions-acc"
                        "username": "jeggo-github-actions-acc"
                        "groups": [
                        "system:masters"
                        ]
                        }]
    map_accounts    = [var.aws_account]

    tags = {
    "cluster_name" = "oss"
    }

    vpc_id = module.vpc.vpc_id

    workers_group_defaults = {
    instance_type  = var.eks_node_type
    root_volume_type = "gp3"
    role_arn = "arn:aws:iam::810711266228:role/eksctl-aws-spin-support-nodegroup-NodeInstanceRole-1HXEJP4FA3D8Z"
    }

    worker_groups = [
    {
        name                          = "oss"
        asg_desired_capacity          = var.eks_node_count
        asg_max_size                  = var.eks_asg_max_size
        target_group_arns             = [aws_lb_target_group.deck-tg.arn, aws_lb_target_group.gate-tg.arn]
    }
    ]

    depends_on = [
        module.vpc
    ]
}