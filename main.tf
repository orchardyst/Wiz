provider "aws" {
  region = var.aws_region
}

module "eks" {
  source = "./eks"
}

module "ec2" {
  source   = "./ec2"
  vpc_id   = module.eks.vpc_id
  subnet_id = module.eks.subnet_ids[0]
}

module "s3" {
  source = "./s3"
}

module "iam" {
  source         = "./iam"
  eks_cluster    = module.eks.cluster_name
  ec2_instance_id = module.ec2.instance_id
}
