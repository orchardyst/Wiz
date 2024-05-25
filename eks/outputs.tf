output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "vpc_id" {
  value = var.vpc_id
}

output "subnet_ids" {
  value = var.subnet_ids
}
