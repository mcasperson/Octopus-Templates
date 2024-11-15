variable "project_k8s___helm_step_deploy_microservice_packageid" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The package ID for the package named  from step Deploy Microservice in project K8s - Helm"
  default     = "echo-server"
}
resource "octopusdeploy_deployment_process" "deployment_process_k8s___helm" {
  project_id = "${octopusdeploy_project.project_k8s___helm.id}"

  step {
    condition           = "Success"
    name                = "Manual Intervention Required"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.Manual"
      name                               = "Manual Intervention Required"
      notes                              = "Require approval for a deployment"
      condition                          = "Success"
      run_on_server                      = false
      is_disabled                        = false
      can_be_used_for_project_versioning = false
      is_required                        = false
      worker_pool_id                     = ""
      properties                         = {
        "Octopus.Action.Manual.Instructions" = "Do you wish to proceed"
        "Octopus.Action.RunOnServer" = "false"
        "Octopus.Action.Manual.BlockConcurrentDeployments" = "False"
      }
      environments                       = []
      excluded_environments              = []
      channels                           = []
      tenant_tags                        = []
      features                           = []
    }

    properties   = {}
    target_roles = []
  }
  step {
    condition           = "Success"
    name                = "Create Namespace"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.KubernetesRunScript"
      name                               = "Create Namespace"
      notes                              = "Creates the namespace if it does not exist."
      condition                          = "Success"
      run_on_server                      = true
      is_disabled                        = false
      can_be_used_for_project_versioning = true
      is_required                        = false
      properties                         = {
        "Octopus.Action.Script.ScriptBody" = "NAMESPACE=mizuho-#{Octopus.Environment.Name | ToLower}\n\nif kubectl get namespace \"$NAMESPACE\" \u003e /dev/null 2\u003e\u00261; then\n  echo \"Namespace '$NAMESPACE' exists.\"\nelse\n  kubectl create ns $NAMESPACE\nfi\n\n"
        "Octopus.Action.Script.ScriptSource" = "Inline"
        "Octopus.Action.Script.Syntax" = "Bash"
        "OctopusUseBundledTooling" = "False"
        "Octopus.Action.RunOnServer" = "true"
      }

      container {
        feed_id = "${data.octopusdeploy_feeds.feed_dockerhub.feeds[0].id}"
        image   = "octopusdeploy/worker-tools:6.3.0-ubuntu.22.04"
      }

      environments          = []
      excluded_environments = []
      channels              = []
      tenant_tags           = []
      features              = []
    }

    properties   = {}
    target_roles = ["eks"]
  }
  step {
    condition           = "Success"
    name                = "Deploy Microservice"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.HelmChartUpgrade"
      name                               = "Deploy Microservice"
      notes                              = "Deploys the microservice Helm chart."
      condition                          = "Success"
      run_on_server                      = true
      is_disabled                        = false
      can_be_used_for_project_versioning = true
      is_required                        = false
      worker_pool_id                     = "${data.octopusdeploy_worker_pools.workerpool_hosted_ubuntu.worker_pools[0].id}"
      properties                         = {
        "Octopus.Action.Helm.ResetValues" = "True"
        "Octopus.Action.Helm.ClientVersion" = "V3"
        "OctopusUseBundledTooling" = "False"
        "Octopus.Action.Script.ScriptSource" = "Package"
        "Octopus.Action.Helm.ReleaseName" = "deploymicroservice-#{Octopus.Environment.Name | ToLower}"
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "Octopus.Action.Helm.Namespace" = "mizuho-#{Octopus.Environment.Name | ToLower}"
        "Octopus.Action.RunOnServer" = "true"
      }

      container {
        feed_id = "${data.octopusdeploy_feeds.feed_dockerhub.feeds[0].id}"
        image   = "octopusdeploy/worker-tools:6.3.0-ubuntu.22.04"
      }

      environments          = []
      excluded_environments = []
      channels              = []
      tenant_tags           = []

      primary_package {
        package_id           = "${var.project_k8s___helm_step_deploy_microservice_packageid}"
        acquisition_location = "Server"
        feed_id              = "${data.octopusdeploy_feeds.feed_echo.feeds[0].id}"
        properties           = { SelectionMode = "immediate" }
      }

      features = []
    }

    properties   = {}
    target_roles = ["eks"]
  }
  depends_on = []
}
