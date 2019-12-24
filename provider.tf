resource "kubernetes_service" "ingress-nginx-service" {
  metadata {
    name      = "${var.deployment_name}-ingress-nginx"
    namespace = kubernetes_namespace.namespace.metadata.0.name
    labels = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
    annotations = var.service_annotations
  }

  spec {
    external_traffic_policy = var.cloud_provider == "node_port" ? "" : "Local"
    type                    = var.cloud_provider == "node_port" ? "NodePort" : "LoadBalancer"
    selector = {
      "app.kubernetes.io/name"    = "ingress-nginx"
      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
    }
  }
}
