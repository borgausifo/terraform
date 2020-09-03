variable "subnet_ids" {
	description = "The subnet IDs to deploy to"
	type = list(string)
}

variable "target_group_arns" {
	description = " ARNs of ELB target groups in which to register Instance"
	type = list(string)
	default = []
}

variable "health_check_type" {
	description = "Type of the health check to perform. Mus be one of: EX2, ELB."
	type = string
	defautl = "EC2"
}

variable "user_data" {
	description = "User Data script to run in each Instance at boot"
	type = string
	default =" " 
}
