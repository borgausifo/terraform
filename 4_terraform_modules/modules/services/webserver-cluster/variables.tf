variable "instance_type" {
    description = "Type of Ec2 instance to run"
    type = string
}

variable "min_size" {
    description = "The minimum numer of EC2 Instances in the ASG"
    type = number
}

variable "max_size" {
    descrtiption = "Maximum number of ec3 instances in the ASG"
    type = number
}