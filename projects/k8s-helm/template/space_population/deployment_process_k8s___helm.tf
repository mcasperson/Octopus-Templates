variable "project_k8s___helm_step_deploy_microservice_packageid" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The package ID for the package named  from step Deploy Microservice in project K8s - Helm"
  default     = "test"
}
resource "octopusdeploy_deployment_process" "deployment_process_k8s___helm" {
  project_id = "${octopusdeploy_project.project_k8s___helm.id}"

  step {
    condition           = "Success"
    name                = "Deploy Microservice"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.HelmChartUpgrade"
      name                               = "Deploy Microservice"
      condition                          = "Success"
      run_on_server                      = false
      is_disabled                        = false
      can_be_used_for_project_versioning = true
      is_required                        = false
      properties                         = {
        "Octopus.Action.Helm.ResetValues" = "True"
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "Octopus.Action.Script.ScriptSource" = "Package"
        "Octopus.Action.RunOnServer" = "false"
        "Octopus.Action.Helm.ClientVersion" = "V3"
        "Octopus.Action.Helm.Namespace" = "mizuho"
      }
      environments                       = []
      excluded_environments              = []
      channels                           = []
      tenant_tags                        = []

      primary_package {
        package_id           = "${var.project_k8s___helm_step_deploy_microservice_packageid}"
        acquisition_location = "Server"
        feed_id              = "${data.octopusdeploy_feeds.feed_octopus_server__built_in_.feeds[0].id}"
        properties           = { SelectionMode = "immediate" }
      }

      features = []
    }

    properties   = {}
    target_roles = ["eks"]
  }
  depends_on = []
}
