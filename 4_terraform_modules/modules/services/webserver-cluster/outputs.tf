output "asg_name" {
    value = aws_auto_scaling_group.example.asg_name
    description = "Name of the Auto Scaling Group"
}

output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "Domain name of the load balancer"
    # Needed for what URL to test when the cluster id deployed.
}