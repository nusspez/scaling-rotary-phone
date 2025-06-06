module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # Usa una versión reciente y estable

  cluster_name    = "${var.project_name}-eks-cluster"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids # Los nodos EKS suelen ir en subnets privadas

  # Configuración del grupo de nodos gestionado por EKS
  eks_managed_node_groups = {
    main_nodes = {
      name           = "${var.project_name}-ng"
      instance_types = var.node_group_instance_types
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size

      # Aquí puedes añadir más configuraciones como etiquetas, taints, etc.
      # Asegúrate que el rol IAM de los nodos tenga los permisos necesarios
      # (el módulo los crea por defecto si no se especifica un rol existente)
    }
  }

  # Habilitar el acceso público al endpoint del clúster para empezar
  # En producción, considera restringir esto.
  cluster_endpoint_public_access = true

  tags = {
    Project     = var.project_name
    Environment = "eks-infra"
  }
}