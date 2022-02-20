# # This TF spins up a basic AMZ Linux machine to do DB setup

# resource "tls_private_key" "this" {
#     algorithm = "RSA"
# }

# module "key_pair" {
#     source = "terraform-aws-modules/key-pair/aws"
#     version = "1.0.1"

#     key_name   = "oss-key-${random_integer.instance_id}"
#     public_key = tls_private_key.this.public_key_openssh
# }

# resource "aws_instance" "sql_bastion" {
#     key_name                             = module.key_pair.key_pair_key_name
#     ami                                  = data.aws_ami.amazon-2.id
#     instance_type                        = "t2.micro"
#     associate_public_ip_address          = true
#     subnet_id                            = module.vpc.public_subnets[0]
#     security_groups                      = ["${aws_security_group.db_setup.id}"]
#     instance_initiated_shutdown_behavior = "terminate"

#     tags = {
#         "Name" = "oss-bastion"
#     }

#     connection {
#         type        = "ssh"
#         user        = "ec2-user"
#         private_key = tls_private_key.this.private_key_pem
#         host        = self.public_ip
#     }

#     provisioner "remote-exec" {
#         inline = [
#         "sudo yum -y install mysql",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"CREATE DATABASE IF NOT EXISTS \\`clouddriver\\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci\";",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, EXECUTE, SHOW VIEW ON \\`clouddriver\\`.* TO 'clouddriver_service'@'%'\";",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, LOCK TABLES, EXECUTE, SHOW VIEW ON \\`clouddriver\\`.* TO \\`clouddriver_migrate\\`@'%'\";",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"CREATE DATABASE IF NOT EXISTS \\`orca\\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci\";",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON \\`orca\\`.* TO 'orca_service'@'%'\";",
#         "mysql -u ${module.cluster.cluster_master_username} -p${module.cluster.cluster_master_password} -h ${module.cluster.cluster_endpoint}  --execute \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, LOCK TABLES, EXECUTE, SHOW VIEW ON \\`orca\\`.* TO 'orca_migrate'@'%'\";",
#         ]
#     }
#     depends_on = [
#         module.cluster
#     ]
# }