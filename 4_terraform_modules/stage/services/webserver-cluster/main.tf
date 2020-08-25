provider "aws" {
	region = "us-east-1"
}

module "webserver_cluster" {
	# Source of the module file located in modules folder
	source = "../../../modules/services/webserver-cluster"
}
