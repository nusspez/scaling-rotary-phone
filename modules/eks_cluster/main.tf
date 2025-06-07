module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks-cluster"
  cluster_version = var.eks_cluster_version # <-- Aquí ya usas la variable correcta

  vpc_id       = var.vpc_id
  subnet_ids = var.private_subnet_ids # Los nodos EKS suelen ir en subnets privadas

  # Configuración del grupo de nodos gestionado por EKS
  eks_managed_node_groups = {
    main_nodes = {
      name           = "${var.project_name}-ng"
      instance_types = var.eks_node_group_instance_types # <--- ¡CAMBIADO AQUÍ!
      min_size       = var.eks_node_group_min_size       # <--- ¡Necesitarás definir esta variable también!
      max_size       = var.eks_node_group_max_size       # <--- ¡Necesitarás definir esta variable también!
      desired_size   = var.eks_node_group_desired_size   # <--- ¡CAMBIADO AQUÍ!

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