resource "kubernetes_pod" "aimotive-flask-pod" {
    depends_on = [var.redis_ready]
    metadata {
        name = "k8s-flask-pod-aimotive"
        namespace   = "k8s-ns-aimotive"
        labels = {
            app = "aimotive-flask-app"
        }
    }
    spec {
        container {
            image   = var.flask_image_name
            name    = "flask"
            image_pull_policy = "Always"
            command = [ "python3", "/app.py" ]
            args = ["k8s-redis-svc-aimotive.k8s-ns-aimotive.svc.cluster.local"]
            port {
              container_port = 5000
            }
            liveness_probe {
                exec {
                    command = [ "sh", "-c", "curl -s localhost:5000/healthz | grep 'ok'" ]
                }
                initial_delay_seconds = "15"

            }
        }
    }
}

resource "kubernetes_service" "aimotive-flask-svc" {
    metadata {
        name = "k8s-flask-svc-aimotive"
        namespace   = "k8s-ns-aimotive"
    }
    spec {
        selector = {
            app = kubernetes_pod.aimotive-flask-pod.metadata.0.labels.app
        }
        port {
            protocol = "TCP"
            port = 5000
            target_port = 5000
        }
        type = "NodePort"
    }
}

variable "redis_ready" {
    type = any
    default = []
}