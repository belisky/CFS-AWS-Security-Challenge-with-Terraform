 # creating vpc
resource "aws_vpc" "cloudforce_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "${var.environment_name}-vpc"
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.cloudforce_vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "${var.environment_name}-public-subnet-${count.index + 1}"
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.cloudforce_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "${var.environment_name}-private-subnet-${count.index + 1}"
  }
}


# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudforce_vpc.id
  tags = {
    Name = "${var.environment_name}-igw"
  }
}

#pulic route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cloudforce_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environment_name}-PRT"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

data "aws_availability_zones" "available" {}
