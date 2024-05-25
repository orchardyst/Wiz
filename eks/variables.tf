variable "project_name" {
  description = "Project name to prefix resources."
  default     = "wiz-project"
}

variable "vpc_id" {
  description = "VPC ID for the resources."
}

variable "subnet_ids" {
  description = "Subnet IDs for the EKS cluster."
  type        = list(string)
}
