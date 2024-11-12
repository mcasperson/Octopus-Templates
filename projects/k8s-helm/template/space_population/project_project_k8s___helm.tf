variable "project_k8s___helm_name" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The name of the project exported from K8s - Helm"
  default     = "K8s - Helm"
}
variable "project_k8s___helm_description_prefix" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "An optional prefix to add to the project description for the project K8s - Helm"
  default     = ""
}
variable "project_k8s___helm_description_suffix" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "An optional suffix to add to the project description for the project K8s - Helm"
  default     = ""
}
variable "project_k8s___helm_description" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The description of the project exported from K8s - Helm"
  default     = "[GitHub Repo](https://github.com/mcasperson/Octopus-Templates)"
}
variable "project_k8s___helm_tenanted" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The tenanted setting for the project Untenanted"
  default     = "Untenanted"
}
resource "octopusdeploy_project" "project_k8s___helm" {
  name                                 = "${var.project_k8s___helm_name}"
  auto_create_release                  = false
  default_guided_failure_mode          = "EnvironmentDefault"
  default_to_skip_if_already_installed = false
  discrete_channel_release             = false
  is_disabled                          = false
  is_version_controlled                = false
  lifecycle_id                         = "${data.octopusdeploy_lifecycles.lifecycle_default_lifecycle.lifecycles[0].id}"
  project_group_id                     = "${data.octopusdeploy_project_groups.project_group_default_project_group.project_groups[0].id}"
  included_library_variable_sets       = []
  tenanted_deployment_participation    = "${var.project_k8s___helm_tenanted}"

  connectivity_policy {
    allow_deployments_to_no_targets = false
    exclude_unhealthy_targets       = false
    skip_machine_behavior           = "None"
  }

  lifecycle {
    ignore_changes = ["connectivity_policy"]
  }
  description = "${var.project_k8s___helm_description_prefix}${var.project_k8s___helm_description}${var.project_k8s___helm_description_suffix}"
}
