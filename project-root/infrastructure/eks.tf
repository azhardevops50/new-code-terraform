resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    # subnet_ids = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
    subnet_ids = concat(
      [for subnet in aws_subnet.public : subnet.id],
      [for subnet in aws_subnet.private : subnet.id]
    )
  }

  tags    = var.tags
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [for each in aws_subnet.private : subnet.id]

  scaling_config {
    desired_size = var.node_group_size.desired
    min_size     = var.node_group_size.min
    max_size     = var.node_group_size.max
  }

  instance_types = [var.node_instance_type]
  tags           = var.tags
}
