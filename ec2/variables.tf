variable "project_name" {
  description = "Project name to prefix resources."
  default     = "wiz-project"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  default     = "ami-0c55b159cbfafe1f0"  // Example AMI ID, please replace with actual
}

variable "instance_type" {
  description = "Instance type for the EC2 instance."
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "VPC ID for the resources."
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance."
}
