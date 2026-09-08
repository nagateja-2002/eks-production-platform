resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = aws_iam_role.eks_node.arn

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  instance_types = ["t3.small"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 4
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "application"
  }

  tags = {
    Name    = "${var.project_name}-nodes"
    Project = var.project_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only
  ]
}