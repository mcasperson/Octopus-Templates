variable "k8s_helm_template_kubernetes_namespace_1" {
  type        = string
  nullable    = true
  sensitive   = false
  description = "The value associated with the variable Kubernetes.Namespace"
  default     = "platformteam"
}
resource "octopusdeploy_variable" "k8s_helm_template_kubernetes_namespace_1" {
  owner_id     = "${octopusdeploy_project.project_k8s_helm_template.id}"
  value        = "${var.k8s_helm_template_kubernetes_namespace_1}"
  name         = "Kubernetes.Namespace"
  type         = "String"
  is_sensitive = false
}
