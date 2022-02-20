resource "kubernetes_namespace" "operator-ns" {
    metadata {
    name = "spinnaker-operator"
    }
}

resource "kubernetes_namespace" "spinnaker-ns" {
    metadata {
    name = "spinnaker"
    }
}

resource "kubernetes_namespace" "target-ns" {
    metadata {
    name = "oss-kubernetes"
    }
}