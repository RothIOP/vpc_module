resource "aws_eip" "nat" {
  count = "${local.az_count}"
  vpc = true
}

resource "aws_nat_gateway" "main" {
  count = "${local.az_count}"
  allocation_id = "${aws_eip.nat.id[count.index]}"
  subnet_id = "${aws_subnet.public.id[count.index]}"

  tags = "${var.tag_block}"
}

