provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "../modules/vpc"
  name   = "dev"
  cidr   = "172.17.0.0/16"

  azs                = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets     = ["172.17.1.0/24", "172.17.3.0/24"]
  private_subnets    = ["172.17.101.0/24", "172.17.103.0/24"]
  restricted_subnets = ["172.17.201.0/24", "172.17.203.0/24"]

  # VPC module이 생성하는 모든 리소스에 기본으로 입력될 Tag를 정의한다.
  tags = {
    "TerraformManaged" = "true",
    "Environment"      = "dev"
  }
}

module "key_pair" {
  source = "../modules/key-pair"
  # key_name           = "dev-marketplace-front-key"
  key_name           = ["dev-marketplace-front-key", "dev-marketplace-api-key", "test"]
  create_private_key = true
}