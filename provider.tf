terraform {
  backend "s3" {
    bucket = "wordpress-on-aws"
    key    = "wordpress"
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "random" {
}
