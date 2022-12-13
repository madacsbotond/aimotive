resource "kubernetes_namespace" "aimotive-ns" {
    metadata {
        name = "k8s-ns-aimotive"
    }
}