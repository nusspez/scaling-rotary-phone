module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks-cluster"
  cluster_version = var.cluster_version # <-- ¡CORREGIDO! Antes era var.eks_cluster_version

  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  # Configuración del grupo de nodos gestionado por EKS
  eks_managed_node_groups = {
    main_nodes = {
      name           = "${var.project_name}-ng"
      instance_types = var.node_group_instance_types # <-- ¡CORREGIDO! Antes era var.eks_node_group_instance_types
      min_size       = var.node_group_min_size       # <-- ¡CORREGIDO! Antes era var.eks_node_group_min_size
      max_size       = var.node_group_max_size       # <-- ¡CORREGIDO! Antes era var.eks_node_group_max_size
      desired_size   = var.node_group_desired_size   # <-- ¡CORREGIDO! Antes era var.eks_node_group_desired_size

      # Aquí puedes añadir más configuraciones como etiquetas, taints, etc.
    }
  }

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  tags = {
    Project     = var.project_name
    Environment = "eks-infra"
  }
}