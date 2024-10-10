provider "aws" {
  region = "us-east-2"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web-app"
  }
}

# Subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet Az1"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "web-IG"
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public route table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group for EKS Cluster
resource "aws_security_group" "web_cluster_sg" {
  name   = "dev-sg"
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-cluster-sg"
  }
}

# Security Group for EKS Nodes
resource "aws_security_group" "web_node_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-node-sg"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "devopsola" {
  name     = "devopsola-cluster"
  role_arn = aws_iam_role.devopsola_cluster_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_az1.id]
    security_group_ids = [aws_security_group.web_cluster_sg.id]
  }
}

# EKS Node Group
resource "aws_eks_node_group" "devopsola_node_group" {
  cluster_name    = aws_eks_cluster.devopsola.name
  node_group_name = "devopsola-node-group"
  node_role_arn   = aws_iam_role.devopsola_node_group_role.arn
  subnet_ids      = [aws_subnet.public_subnet_az1.id]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  instance_types = ["t2.large"]

  remote_access {
    ec2_ssh_key = "project2"  # Provide your SSH key name here
    source_security_group_ids = [aws_security_group.web_node_sg.id]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "devopsola_cluster_role" {
  name = "devopsola-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach Policy to Cluster Role
resource "aws_iam_role_policy_attachment" "devopsola_cluster_role_policy" {
  role       = aws_iam_role.devopsola_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "devopsola_node_group_role" {
  name = "devopsola-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach Policies to Node Group Role
resource "aws_iam_role_policy_attachment" "devopsola_node_group_role_policy" {
  role       = aws_iam_role.devopsola_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "devopsola_node_group_cni_policy" {
  role       = aws_iam_role.devopsola_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "devopsola_node_group_registry_policy" {
  role       = aws_iam_role.devopsola_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
