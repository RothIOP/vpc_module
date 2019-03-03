data "aws_availability_zone" "available" {
  state = "available"
}

locals {
  az_count = "${length(data.aws_availability_zone.available.*.names)}"
}


resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = "${var.dns_support}"
  tags = "${var.tag_block}"
}

resource "aws_subnet" "public" {
  count = "${local.az_count}"
  vpc_id = "${aws_vpc.main.id}"

  //Creates one public subnet per availability zone. Assumes 8 possible subnets, but will create 16 if using a region with >4 AZ's.
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 
  length(aws_availability_zones.available.*.names) > 4 ? 4 : 3, 
  count.index)}"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = "${local.az_count}"
  vpc_id = "${aws_vpc.main.id}"

  //Creates one private subnet per availability zone. Assumes 8 possible subnets, but will create 16 if using a region with >4 AZ's.
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 
  length(aws_availability_zones.available.*.names) > 4 ? 4 : 3, 
  count.index+local.az_count)}"

  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${var.tag_block}"
}
