# SG to attach to ALB that only allows 443 (maybe 80??)
resource "aws_security_group" "ALB_SG" {
    name_prefix = "oss-${random_integer.instance_id.result}-alb-SG"
    vpc_id      = module.vpc.vpc_id

    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    "Name" = "oss-${random_integer.instance_id.result}"
    }
}

# This SG allows traffic coming from the LB only
resource "aws_security_group" "worker_node_sg" {
    name_prefix = "oss-${random_integer.instance_id.result}-alb-to-node"
    vpc_id      = module.vpc.vpc_id

    ingress {
        security_groups = [aws_security_group.ALB_SG.id]
        from_port        = 0
        to_port          = 0
        protocol  = "-1"
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    "Name" = "oss-${random_integer.instance_id.result}"
    }
}

# SG to attch to DB to allow node comms
resource "aws_security_group" "database_sg" {
    name_prefix = "oss-${random_integer.instance_id.result}-node-to-db"
    vpc_id = module.vpc.vpc_id

    ingress {
        security_groups = [aws_security_group.worker_node_sg.id]
        from_port        = 3306
        to_port          = 3306
        protocol  = "tcp"
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    "Name" = "oss-${random_integer.instance_id.result}"
    }

}

# resource "aws_security_group" "db_setup" {
#     name_prefix = "oss-${random_integer.instance_id.result}-DB_SETUP-"
#     vpc_id = module.vpc.vpc_id

#         ingress {
#         from_port        = 22
#         to_port          = 22
#         protocol  = "tcp"
#         cidr_blocks      = ["0.0.0.0/0"]
#     }

#     egress {
#         from_port        = 0
#         to_port          = 0
#         protocol         = "-1"
#         cidr_blocks      = ["0.0.0.0/0"]
#     }
# }