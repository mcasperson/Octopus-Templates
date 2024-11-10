resource "octopusdeploy_runbook_process" "runbook_process_k8s___helm_uninstall_helm_chart" {
  runbook_id = "${octopusdeploy_runbook.runbook_k8s___helm_uninstall_helm_chart.id}"

  step {
    condition           = "Success"
    name                = "Run a kubectl script"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.KubernetesRunScript"
      name                               = "Run a kubectl script"
      condition                          = "Success"
      run_on_server                      = true
      is_disabled                        = false
      can_be_used_for_project_versioning = true
      is_required                        = false
      properties                         = {
        "Octopus.Action.Script.ScriptBody" = "helm uninstall deploymicroservice-#{Octopus.Environment.Name | ToLower}"
        "Octopus.Action.KubernetesContainers.Namespace" = "mizuho-#{Octopus.Environment.Name | ToLower}"
        "Octopus.Action.RunOnServer" = "true"
        "OctopusUseBundledTooling" = "False"
        "Octopus.Action.Script.ScriptSource" = "Inline"
        "Octopus.Action.Script.Syntax" = "Bash"
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
  depends_on = []
}
