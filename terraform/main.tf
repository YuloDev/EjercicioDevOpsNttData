provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./network"
}

module "ecr" {
  source = "./ecr"
}

module "ecs" {
  source = "./ecs"
}

module "security" {
  source = "./security_groups"
}
