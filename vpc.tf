# Create a VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc_cidr

  tags = map(
    "Name", "eks-vpc",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

# Create a Public Subnet
resource "aws_subnet" "eks-pub-subnet" {
  count      = length(var.pub_subnet_cidr)  
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = var.pub_subnet_cidr[count.index]
  map_public_ip_on_launch = true

  tags = map(
    "Name", "eks-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

# Create a Internet Gateway
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-igw"
  }
}

# Create a Public Route Table
resource "aws_route_table" "eks-pub-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }

  tags = {
    Name = "eks-pub-rt"
  }  
}

# Create a Public Route Table Association
resource "aws_route_table_association" "pub-rt-association" {
  count          = length(var.pub_subnet_cidr)   

  subnet_id      = aws_subnet.eks-pub-subnet[count.index].id
  route_table_id = aws_route_table.eks-pub-rt.id
}
