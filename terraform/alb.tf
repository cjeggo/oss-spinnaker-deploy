resource "aws_acm_certificate" "cert" {
    domain_name       = "*.${var.domain_name}"
    validation_method = "DNS"

    tags = {
        "Name" = "oss-${random_integer.instance_id.result}-cert"
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "cert_val" {
    certificate_arn = aws_acm_certificate.cert.arn
    depends_on = [
        aws_acm_certificate.cert
    ]
}

resource "aws_lb" "spin-alb" {
    name = "oss-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.ALB_SG.id]
    subnets = module.vpc.public_subnets
}

resource "aws_lb_target_group" "deck-tg" {
    name = "oss-${random_integer.instance_id.result}-deck"
    port = 31015
    protocol = "HTTP"
    vpc_id = module.vpc.vpc_id
}

resource "aws_lb_target_group" "gate-tg" {
    name = "oss-${random_integer.instance_id.result}-gate"
    port = 30586
    protocol = "HTTP"
    vpc_id = module.vpc.vpc_id
    health_check {
        path = "/health"
    }
}

resource "aws_lb_listener" "spin-listener-https" {
    load_balancer_arn = aws_lb.spin-alb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = aws_acm_certificate.cert.arn

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.deck-tg.arn
    }

    depends_on = [
        aws_acm_certificate_validation.cert_val
    ]

}

resource "aws_lb_listener_rule" "forward-deck" {
    listener_arn = aws_lb_listener.spin-listener-https.arn

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.deck-tg.arn
    }

    condition {
        host_header {
            values = [aws_route53_record.deck-record.name]
        }
    }

    depends_on = [
        aws_lb_target_group.deck-tg
    ]
}

resource "aws_lb_listener_rule" "forward-gate" {
    listener_arn = aws_lb_listener.spin-listener-https.arn

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.gate-tg.arn
    }

    condition {
        host_header {
            values = [aws_route53_record.gate-record.name]
        }
    }

    depends_on = [
        aws_lb_target_group.gate-tg
    ]
}

