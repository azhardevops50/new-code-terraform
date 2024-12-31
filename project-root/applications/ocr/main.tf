resource "kubernetes_namespace" "ocr" {
  metadata {
    name = "ocr"
  }
}

resource "kubernetes_deployment" "ocr" {
  metadata {
    name      = "ocr-django"
    namespace = kubernetes_namespace.ocr.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "ocr-django" }
    }

    template {
      metadata {
        labels = { app = "ocr-django" }
      }

      spec {
        container {
          name  = "ocr-django"
          image = "${aws_ecr_repository.ocr_django.repository_url}:${var.image_tag}"

          resources {
            limits {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          ports {
            container_port = 8000
          }

          env_from {
            secret_ref {
              name = "ocr-secrets"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ocr" {
  metadata {
    name      = "ocr-service"
    namespace = kubernetes_namespace.ocr.metadata[0].name
  }

  spec {
    type = "LoadBalancer"
    selector = {
      app = "ocr-django"
    }

    port {
      port        = 80
      target_port = 8000
    }
  }
}
