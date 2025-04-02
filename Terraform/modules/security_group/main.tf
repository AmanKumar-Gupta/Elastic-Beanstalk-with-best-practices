resource "aws_security_group" "main" {
  name        = "${var.environment}-${var.name}"
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.environment}-${var.name}"
    },
    var.tags
  )

  # Explicitly add a lifecycle rule to create the replacement security group before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}

# Ingress rules - from CIDR blocks
resource "aws_security_group_rule" "ingress_cidr" {
  count = length(var.ingress_cidr_rules)

  security_group_id = aws_security_group.main.id
  type              = "ingress"
  
  from_port         = var.ingress_cidr_rules[count.index].from_port
  to_port           = var.ingress_cidr_rules[count.index].to_port
  protocol          = var.ingress_cidr_rules[count.index].protocol
  cidr_blocks       = var.ingress_cidr_rules[count.index].cidr_blocks
  description       = lookup(var.ingress_cidr_rules[count.index], "description", null)
}

# Ingress rules - from security groups
resource "aws_security_group_rule" "ingress_sg" {
  count = length(var.ingress_sg_rules)

  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  
  from_port                = var.ingress_sg_rules[count.index].from_port
  to_port                  = var.ingress_sg_rules[count.index].to_port
  protocol                 = var.ingress_sg_rules[count.index].protocol
  source_security_group_id = var.ingress_sg_rules[count.index].source_security_group_id
  description              = lookup(var.ingress_sg_rules[count.index], "description", null)
}

# Egress rules - to CIDR blocks
resource "aws_security_group_rule" "egress_cidr" {
  count = length(var.egress_cidr_rules)

  security_group_id = aws_security_group.main.id
  type              = "egress"
  
  from_port         = var.egress_cidr_rules[count.index].from_port
  to_port           = var.egress_cidr_rules[count.index].to_port
  protocol          = var.egress_cidr_rules[count.index].protocol
  cidr_blocks       = var.egress_cidr_rules[count.index].cidr_blocks
  description       = lookup(var.egress_cidr_rules[count.index], "description", null)
}

# Egress rules - to security groups
resource "aws_security_group_rule" "egress_sg" {
  count = length(var.egress_sg_rules)

  security_group_id        = aws_security_group.main.id
  type                     = "egress"
  
  from_port                = var.egress_sg_rules[count.index].from_port
  to_port                  = var.egress_sg_rules[count.index].to_port
  protocol                 = var.egress_sg_rules[count.index].protocol
  source_security_group_id = var.egress_sg_rules[count.index].source_security_group_id
  description              = lookup(var.egress_sg_rules[count.index], "description", null)
}

# Add default allow all outbound rule if specified
resource "aws_security_group_rule" "allow_all_outbound" {
  count = var.allow_all_outbound ? 1 : 0

  security_group_id = aws_security_group.main.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}
