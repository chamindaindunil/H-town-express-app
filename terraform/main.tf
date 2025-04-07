provider "local" {}

# Start Minikube
resource "null_resource" "minikube" {
  provisioner "local-exec" {
    command = "minikube start --driver=docker"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Enable Ingress Controller in Minikube
resource "null_resource" "ingress_controller" {
  depends_on = [null_resource.minikube]

  provisioner "local-exec" {
    command = "minikube addons enable ingress"
  }
}

# Output kubeconfig file for kubectl
output "kubeconfig" {
  value = "export KUBEVIRT_KUBEVIRT_API_SERVER=$(minikube ip):8443; export KUBEVIRT_KUBEVIRT_KUBECONFIG=$(minikube kubeconfig)"
}