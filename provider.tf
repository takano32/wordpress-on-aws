terraform {
  backend "s3" {
    bucket = "wordpress-on-aws"
    key    = "wordpress.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

provider "aws" {
  alias = "tokyo"
  region = "ap-northeast-1"
}

provider "random" {
}
