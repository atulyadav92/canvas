provider "aws" {
  profile = var.profile
  region  = var.region
}

module "VPC" {
  source       = "../modules/VPC"
  name         = var.name
  cidr         = var.cidr
  sbn_cidr_pbl = var.sbn_cidr_pbl
  sbn_cidr_pvt = var.sbn_cidr_pvt
}


module "EKS" {
  depends_on   = [module.VPC]
  source       = "../modules/EKS"
  vpc_id       = module.VPC.vpc_id
  cluster_name = var.cluster_name
  subnet_pvt   = module.VPC.subnet_pbl_id
  desired_size = var.desired_size
  max_size     = var.max_size
  min_size     = var.min_size
  k8s_version  = var.k8s_version
}
