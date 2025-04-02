# Create Elastic IPs for the NAT Gateways
resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : length(var.public_subnet_ids)

  domain = "vpc"

  tags = merge(
    {
      Name = "${var.environment}-nat-eip-${count.index + 1}"
    },
    var.tags
  )

  depends_on = [var.igw_id]
}

# Create NAT Gateways in the public subnets
resource "aws_nat_gateway" "nat" {
  count = var.single_nat_gateway ? 1 : length(var.public_subnet_ids)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(
    {
      Name = "${var.environment}-nat-gateway-${count.index + 1}"
    },
    var.tags
  )

  # To ensure proper ordering, specify that the NAT Gateway depends on the Internet Gateway
  depends_on = [var.igw_id]
}

# Add routes to the private route tables to route through NAT Gateways
resource "aws_route" "private_nat_gateway" {
  count = length(var.private_route_table_ids)

  route_table_id         = var.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.nat[0].id : aws_nat_gateway.nat[count.index % length(aws_nat_gateway.nat)].id
}
