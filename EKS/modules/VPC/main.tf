###########################
######    VPC  ############
###########################
resource "aws_vpc" "vpc_canvas" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = join("",[var.name,"_vpc"])
  }
}
###########################
######  SUBNET ############
###########################

data "aws_availability_zones" "available" {}

resource "aws_subnet" "sbn_canvas_pvt" {
  count = length(var.sbn_cidr_pvt)
  map_public_ip_on_launch = true
  cidr_block = var.sbn_cidr_pvt[count.index]
  vpc_id = aws_vpc.vpc_canvas.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("",[var.name,"_sbn_pvt"])
  }
}
resource "aws_subnet" "sbn_canvas_pbl" {
  count = length(var.sbn_cidr_pbl)
  map_public_ip_on_launch = true
  cidr_block = var.sbn_cidr_pbl[count.index]
  vpc_id = aws_vpc.vpc_canvas.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = join("",[var.name,"_sbn_pbl"])
  }
}
###########################
######    IGW  ############
###########################
resource "aws_internet_gateway" "igw_canvas" {
 vpc_id = aws_vpc.vpc_canvas.id
  tags = {
    Name = join("",[var.name,"_igw"])
  }
 }
###########################
######    EIP  ############
###########################
resource "aws_eip" "eip_canvas" {
  vpc = true
}
###########################
######    NAT  ############
###########################
resource "aws_nat_gateway" "nat_canvas" {
  allocation_id = aws_eip.eip_canvas.id
  subnet_id = element(aws_subnet.sbn_canvas_pvt.*.id, 0)
  tags = {
    Name = join("",[var.name,"_nat"])
  }
}
###########################
###### ROUTE TABLE ########
###########################
//private
resource "aws_route_table" "rt_canvas_pvt" {
  vpc_id = aws_vpc.vpc_canvas.id
  tags = {
    Name = join("",[var.name,"_rt"])
  }
}
//public
resource "aws_route_table" "rt_canvas_pbl" {
  vpc_id = aws_vpc.vpc_canvas.id
  tags = {
    Name = join("",[var.name,"_pbl"])
  }
}
###########################
######    ROUTE    ########
###########################
//private
resource "aws_route" "igw" {
  route_table_id = aws_route_table.rt_canvas_pbl.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_canvas.id
}
//public
resource "aws_route" "nat" {
  route_table_id = aws_route_table.rt_canvas_pvt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_canvas.id
}
###########################
###  ROUTE ASSOCIATION ####
###########################
//public
resource "aws_route_table_association" "pbl_association" {
  count = length(var.sbn_cidr_pbl)
  subnet_id = element(aws_subnet.sbn_canvas_pbl.*.id, count.index)
  route_table_id = aws_route_table.rt_canvas_pbl.id
}
//private
resource "aws_route_table_association" "pvt_association" {
  count = length(var.sbn_cidr_pvt)
  subnet_id = element(aws_subnet.sbn_canvas_pvt.*.id, count.index)
  route_table_id = aws_route_table.rt_canvas_pvt.id
}