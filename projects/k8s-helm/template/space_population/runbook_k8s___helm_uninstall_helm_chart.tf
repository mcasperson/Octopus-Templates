variable "runbook_k8s___helm_uninstall_helm_chart_name" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The name of the runbook exported from Uninstall Helm Chart"
  default     = "Uninstall Helm Chart"
}
resource "octopusdeploy_runbook" "runbook_k8s___helm_uninstall_helm_chart" {
  name                        = "${var.runbook_k8s___helm_uninstall_helm_chart_name}"
  project_id                  = "${octopusdeploy_project.project_k8s___helm.id}"
  environment_scope           = "All"
  environments                = []
  force_package_download      = false
  default_guided_failure_mode = "EnvironmentDefault"
  description                 = ""
  multi_tenancy_mode          = "Untenanted"

  retention_policy {
    quantity_to_keep = 100
  }

  connectivity_policy {
    allow_deployments_to_no_targets = true
    exclude_unhealthy_targets       = false
    skip_machine_behavior           = "None"
  }
}
