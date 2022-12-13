resource "kubernetes_pod" "aimotive-redis-pod" {
    metadata {
        name = "k8s-redis-pod-aimotive"
        namespace   = "k8s-ns-aimotive"
        labels = {
            app = "aimotive-redis-app"
        }
    }
    spec {
        container {
            image   = "redis:7"
            name    = "redis"
            command = [ "redis-server", "/redis/redis.conf" ]
            env {
              name = "MASTER"
              value = "true"
            }
            port {
              container_port = 6379
            }
            resources {
                limits = {
                    cpu = "1.0"
                }
            }
            volume_mount {
                mount_path = "/redis-data"
                name = "data"
            }
            volume_mount {
                mount_path = "/redis"
                name = "config"
            }
        }
        volume {
            name = "data"
            persistent_volume_claim {
                claim_name = "${kubernetes_persistent_volume_claim.aimotive-redis-pvc.metadata.0.name}"
            }
        }
        volume {
            name = "config"
            config_map {
                name = "k8s-redis-configmap-aimotive"
                items {
                  key = "redis-config"
                  path = "redis.conf"
                }
            }
        }
    }
}

resource "kubernetes_service" "aimotive-redis-svc" {
    metadata {
        name = "k8s-redis-svc-aimotive"
        namespace   = "k8s-ns-aimotive"
    }
    spec {
        selector = {
            app = kubernetes_pod.aimotive-redis-pod.metadata.0.labels.app
        }
        port {
            protocol = "TCP"
            port = 6379
            target_port = 6379
        }
    }
}


resource "kubernetes_storage_class" "aimotive-redis-sc" {
    metadata {
        name = "k8s-redis-sc-aimotive"
    }
    storage_provisioner = "kubernetes.io/no-provisioner"
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
    reclaim_policy = "Delete"
}

resource "kubernetes_persistent_volume" "aimotive-redis-pv" {
    metadata {
        name = "k8s-redis-pv-aimotive"
    }
    spec {
        storage_class_name = "k8s-redis-sc-aimotive"
        capacity = {
            storage = "5Gi"
        }
        access_modes = ["ReadWriteOnce"]
        node_affinity {
            required {
                node_selector_term {
                    match_expressions {
                        key = "kubernetes.io/hostname"
                        operator = "In"
                        values = [ "minikube" ]
                    }
                }
            }
        }
        persistent_volume_source {
            local {
                path = "/data/redis-data"
            }
        }
    }
}

resource "kubernetes_persistent_volume_claim" "aimotive-redis-pvc" {
    metadata {
        name = "k8s-redis-pvc-aimotive"
        namespace   = "k8s-ns-aimotive"

  }
  spec {
        access_modes = ["ReadWriteOnce"]
        resources {
            requests = {
                storage = "1Gi"
            }
        }
        storage_class_name = "${kubernetes_storage_class.aimotive-redis-sc.metadata.0.name}"
        volume_name = "${kubernetes_persistent_volume.aimotive-redis-pv.metadata.0.name}"
  }
}

output "redis_ready" {
    value = {}
    depends_on = [kubernetes_pod.aimotive-redis-pod]
}