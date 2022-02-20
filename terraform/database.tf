
# module "cluster" {
#     source         = "terraform-aws-modules/rds-aurora/aws"
#     version        = "6.1.3"
#     name           = "oss-db"
#     engine         = "aurora-mysql"
#     engine_version = "5.7.mysql_aurora.2.07.2"
#     instances = {
#         1 = {
#             identifier          = oss
#             instance_class      = var.db_instance_type
#             publicly_accessible = false
#         }
#     }
#     vpc_id                 = module.vpc.vpc_id
#     db_subnet_group_name   = module.vpc.database_subnet_group_name
#     create_db_subnet_group = false
#     create_security_group  = true
#     allowed_cidr_blocks    = [module.vpc.vpc_cidr_block] # "${module.vpc.private_subnets_cidr_blocks}", "${module.vpc.public_subnets_cidr_blocks}"
#     allowed_security_groups = ["${aws_security_group.database_sg.id}", "${aws_security_group.db_setup.id}", "${module.eks.cluster_primary_security_group_id}"]
#     # vpc_security_group_ids  = ["${aws_security_group.database_sg.id}", "${aws_security_group.db_setup.id}"]

#     autoscaling_enabled      = true
#     autoscaling_min_capacity = 1
#     autoscaling_max_capacity = 5

#     create_random_password      = true
#     master_username             = "ossuser"      # the username cannot have special chars.

#     skip_final_snapshot         = true
# }
