# ----------------------------------------------------------------------------------------------------------------------
# This module requires a terraform version of 0.12.x.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12, < 0.13"
}
# ----------------------------------------------------------------------------------------------------------------------
# Main VPC
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags                 = var.vpc_tags
}
# ----------------------------------------------------------------------------------------------------------------------
# Public Subnets
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]["cidr_block"]
  availability_zone       = lookup(var.public_subnets[count.index], "availability_zone", null)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(
    var.public_subnet_tags,
    {
      Name = var.public_subnets[count.index]["name"]
    }
  )
  depends_on = [
  aws_vpc.main]
}
# ----------------------------------------------------------------------------------------------------------------------
# Private Subnets
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]["cidr_block"]
  availability_zone = lookup(var.private_subnets[count.index], "availability_zone", null)
  tags = merge(
    var.private_subnet_tags,
    {
      Name = var.private_subnets[count.index]["name"]
    }
  )
  depends_on = [
  aws_vpc.main]
}
# ----------------------------------------------------------------------------------------------------------------------
# Database Subnets
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "database" {
  count             = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index]["cidr_block"]
  availability_zone = lookup(var.database_subnets[count.index], "availability_zone", null)
  tags = merge(
    var.database_subnet_tags,
    {
      Name = var.database_subnets[count.index]["name"]
    }
  )
  depends_on = [
  aws_vpc.main]
}