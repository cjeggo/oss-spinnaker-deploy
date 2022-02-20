# S3 bucket for Front 50 and general persistence stuff
resource "aws_s3_bucket" "S3-bucket" {
    bucket = "oss-${random_integer.instance_id.result}-bucket"
    acl    = "private"
    force_destroy = true

    tags = {
    "Name" = "oss-${random_integer.instance_id.result}"
    }
}

resource "aws_s3_bucket_object" "deck_url"{
    bucket      = aws_s3_bucket.S3-bucket.bucket
    key         = "deck-url.txt"
    content     = aws_route53_record.deck-record.name
}

resource "aws_s3_bucket_object" "kubeconfig"{
    bucket = aws_s3_bucket.S3-bucket.bucket
    key    = "kubeconfig"
    source = "oss-kconfig"
}
