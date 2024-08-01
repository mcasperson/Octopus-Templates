variable "k8s___helm_project_packagename_1" {
  type        = string
  nullable    = true
  sensitive   = false
  description = "The value associated with the variable project.packageName"
  default     = "octopusdeploylabs/workertools"
}
resource "octopusdeploy_variable" "k8s___helm_project_packagename_1" {
  owner_id     = "${octopusdeploy_project.project_k8s___helm.id}"
  value        = "${var.k8s___helm_project_packagename_1}"
  name         = "project.packageName"
  type         = "String"
  is_sensitive = false
}
