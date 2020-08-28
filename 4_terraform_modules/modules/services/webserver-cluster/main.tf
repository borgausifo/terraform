terraform {
  required_version = ">= 0.12"
}

locals {
  http_port = 80
  any_port = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-0c55b159cbfafe1f0"
    instance_type = var.instance_type
    security_groups = [aws_security_group.instance.id]
    user_date = data.template_file.user-data.rendered


variable "cluster_name" {
    description = "The name to use for all the cluster resources" 
    type = string
}

variable "db_remote_state_bucket" {
    description = "Name of the s3 bucket for the database's remote state"
    type = string
}

variable "db_remote_state_key" {
    description = "The path to databases remote state in S3"
    type = string
}

resource "aws_security_group" "alb" {
    name = "${var.cluster_name}-alb"

    ingress {
        from_port = local.http_port 
        to_port = local.http_port
        protocol = local.tcp_protocol
        cidr_blocks = local.all_ips 
    }

    egress {
        from_port = local.any_port 
        to_port = local.any_port 
        protocol = local.any_protocol 
        cidr_blocks = local.all_ips 
    }
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-0c55b159cbfafe1f0"
    instance_type = var.instance_type
    security_groups = [aws_security_group.instance.id]
    user_data = data.template_file.user_data.rendered


    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launc_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids
    target_group_arns = [aws_lb_target_group.asg.arn]
    health_check_type = "ELB"

    min_size = var.min_size
    max_size = var.max_size

    tag {
        key = "Name"
        value = var.cluster_name
        propagate_at_launch = true
    }

} 

data "terraform_remote_state" "db" {
    backend = "s3"
    
    config = {
        bucket = var.db_remote_state_bucket
        key = var.db_remote_state_key
        region = "us-east-1"
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn  = aws_lb.example.arn
    port = local.http_port 
    protocol = "HTTP"

    #By default, return a simple 404 page 
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

