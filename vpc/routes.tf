resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route = {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = "${var.tag_block}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"
  count = "${local.az_count}"

  route = {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.main.*.id[count.index]}"
  }

  tags = "${var.tag_block}"
}

//AZ specific route tables use AZ specific NAT Gateway so AZ outage doesn't affect other AZ's
resource "aws_route_table_association" "private" {
  count = "${local.az_count}"
  subnet_id = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}

resource "aws_route_table_association" "public" {
  count = "${local.az_count}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

