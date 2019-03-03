//Single Provider, assumes provider is instantiated
module "vpc" {
  source = "./vpc"
  cidr_block = "10.0.0.0/16" 
}

//Multiple Provider, assumes providers are instantiated
module "vpc_east" {
    source = "./vpc"
    cidr_block = "10.0.0.0/16" 
    providers = {
        aws = "aws.use1"
    }
}

module "vpc_west" {
    source = "./vpc"
    cidr_block = "10.1.0.0/16" 
    providers = {
        aws = "aws.usw1"
    }
}

