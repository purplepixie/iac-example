terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name = "hello-world-example"
    namespace = "davedemo"
    labels = {
      App = "HelloWorldExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "HelloWorldExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "HelloWorldExample"
          namespace = "davedemo"
        }
      }
      spec {
        container {
          image = "rancher/hello-world"
          name  = "helloworlddemo"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "hello" {
  metadata {
    name = "hello-example"
    namespace = "davedemo"
  }
  spec {
    selector = {
      App = kubernetes_deployment.hello.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}


resource "kubernetes_ingress_v1" "hello" {
  metadata {
    name = "davedemo"
    namespace = "davedemo"
  }

  spec {
    rule {
      host = "terraform.dave.qpc.qubcloud.uk"
      http {
        path {
          path = "/"
          backend {
           service {
            name = "hello-example"
            port {
              number = 80
            }
           }
          }
        }
      }
    }
  }

  wait_for_load_balancer = true
}
