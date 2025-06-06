# --- Configuración de Proveedores para Kubernetes ---

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# El proveedor de Kubernetes usa los datos del clúster para saber a dónde conectarse.
provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  # ¡Aquí usamos el token directamente!
  token                  = data.aws_eks_cluster_auth.cluster.token

  # Ya no necesitas el bloque 'exec' porque el token se proporciona directamente.
  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   command     = "aws"
  #   args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
  # }
}

# El proveedor de Helm utiliza la configuración del proveedor de Kubernetes.
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    # ¡Aquí también usamos el token directamente!
    token                  = data.aws_eks_cluster_auth.cluster.token

    # Ya no necesitas el bloque 'exec' aquí tampoco.
    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command     = "aws"
    #   args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    # }
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
  version    = "4.10.1"

  # Espera a que el namespace esté creado antes de intentar instalar
  depends_on = [kubernetes_namespace.ingress_nginx]
}

# --- Instalación del Stack de Monitoreo (Prometheus + Grafana) ---

# Creamos un namespace dedicado para el monitoreo
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Usamos el recurso helm_release para instalar el chart 'kube-prometheus-stack'
resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "58.1.0" # Es bueno fijar una versión estable del chart

  # Espera a que el namespace esté creado antes de intentar instalar
  depends_on = [kubernetes_namespace.monitoring]
}