provider "aws" {
	region = "us-east-1"
}

module "webserver_cluster" {
	# Source of the module file located in modules folder
	source = "../../../modules/services/webserver-cluster"

	cluster_name = "webservers-state"
	db_remote_state_bucket = "Your bucket name"
	db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

	instance_type = "t2.micro"
	min_size = 2
	max_size = 2
}


module "webserver_cluster" {
	source = "github.com/foo/modules/...?ref=v0.0.1"

	cluster_name = "webserver-state"
	db_remote_state_bucket = "..."
	db_remote_state_key = "..."

	instance_type = "t2.micro"
	min_size = 2
	max_size = 2
}



