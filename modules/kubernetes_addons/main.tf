# --- Configuración de Proveedores para Kubernetes ---

# El proveedor de Kubernetes usa los datos del clúster para saber a dónde conectarse.
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)

  # La autenticación se obtiene automáticamente de tu configuración de AWS CLI
  # (del comando 'aws eks update-kubeconfig' que ejecutaste antes)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

# El proveedor de Helm utiliza la configuración del proveedor de Kubernetes.
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

# --- Instalación del Nginx Ingress Controller ---

# Creamos un namespace dedicado para el Ingress Controller
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# Usamos el recurso helm_release para instalar el chart
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  version    = "4.10.1" # Es bueno fijar una versión del chart

  # Espera a que el namespace esté creado antes de intentar instalar
  depends_on = [kubernetes_namespace.ingress_nginx]
}