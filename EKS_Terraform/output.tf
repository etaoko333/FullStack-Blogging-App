output "cluster_id" {
  value = aws_eks_cluster.devopsola.id
}

output "node_group_id" {
  value = aws_eks_node_group.devopsola.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = aws_subnet.public_subnet_az1[*].id
}

