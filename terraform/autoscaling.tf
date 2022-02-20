resource "aws_autoscaling_schedule" "nightly-shutdown" {
    scheduled_action_name  = "nightly-shutdown"
    min_size               = 0     # -1 means don't change it
    max_size               = 0
    desired_capacity       = 0
    start_time             = "${formatdate("YYYY-MM-DD", timestamp())}T19:00:00Z"
    time_zone              = "${var.timezone[var.aws_region]}"
    recurrence             = "0 19 * * 1-5"
    autoscaling_group_name = "${data.aws_autoscaling_groups.asg.names[0]}"
}

resource "aws_autoscaling_schedule" "morning-scale" {
    scheduled_action_name  = "morning-startup"
    min_size               = 1
    max_size               = var.eks_asg_max_size
    desired_capacity       = var.eks_node_count
    start_time             = "${formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))}T08:00:00Z"    # cannot be in the past so add 24 hours to make it tomorrow
    time_zone              = "${var.timezone[var.aws_region]}"
    recurrence             = "0 8 * * 1-5"
    autoscaling_group_name = "${data.aws_autoscaling_groups.asg.names[0]}"
}

resource "time_static" "date" {}