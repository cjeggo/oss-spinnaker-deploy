
resource "aws_route53_record" "gate-record" {
    zone_id = var.route53_primary_zone_id
    name    = "oss-gate.${var.domain_name}"
    type    = "A"

    alias {
    name                   = aws_lb.spin-alb.dns_name
    zone_id                = aws_lb.spin-alb.zone_id
    evaluate_target_health = false
    }

    depends_on = [
        aws_lb.spin-alb
    ]
}

resource "aws_route53_record" "deck-record" {
    zone_id = var.route53_primary_zone_id
    name    = "oss-${random_integer.instance_id.result}.${var.domain_name}"
    type    = "A"

    alias {
    name                   = aws_lb.spin-alb.dns_name
    zone_id                = aws_lb.spin-alb.zone_id
    evaluate_target_health = false
    }

    depends_on = [
        aws_lb.spin-alb
    ]
}

# resource "local_file" "deck_url" {
#     content     = aws_route53_record.deck-record.name
#     filename = "deck_url.txt"
# }

