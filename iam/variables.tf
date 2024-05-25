variable "project_name" {
  description = "Project name to prefix resources."
  default     = "wiz-project"
}

variable "eks_cluster" {
  description = "Name of the EKS cluster."
}

variable "ec2_instance_id" {
  description = "ID of the EC2 instance."
}
