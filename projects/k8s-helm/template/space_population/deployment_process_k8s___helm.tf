variable "project_k8s___helm_step_deploy_a_helm_chart_packageid" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The package ID for the package named  from step Deploy a Helm Chart in project K8s - Helm"
  default     = "petclinic-chart"
}
variable "project_k8s___helm_step_deploy_a_helm_chart_package_worker_image_packageid" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The package ID for the package named Worker Image from step Deploy a Helm Chart in project K8s - Helm"
  default     = "#{project.packageName}"
}
resource "octopusdeploy_deployment_process" "deployment_process_k8s___helm" {
  project_id = "${octopusdeploy_project.project_k8s___helm.id}"

  step {
    condition           = "Success"
    name                = "Deploy a Helm Chart"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.HelmChartUpgrade"
      name                               = "Deploy a Helm Chart"
      condition                          = "Success"
      run_on_server                      = false
      is_disabled                        = false
      can_be_used_for_project_versioning = true
      is_required                        = false
      properties                         = {
        "Octopus.Action.Helm.ResetValues" = "True"
        "Octopus.Action.Package.DownloadOnTentacle" = "False"
        "Octopus.Action.RunOnServer" = "false"
        "Octopus.Action.Helm.ClientVersion" = "V3"
      }
      environments                       = []
      excluded_environments              = []
      channels                           = []
      tenant_tags                        = []

      package {
        name                      = "Worker Image"
        package_id                = "${var.project_k8s___helm_step_deploy_a_helm_chart_package_worker_image_packageid}"
        acquisition_location      = "NotAcquired"
        extract_during_deployment = false
        feed_id                   = "${data.octopusdeploy_feeds.feed_ghcr.feeds[0].id}"
        properties                = { Extract = "False", Purpose = "DockerImageReference", SelectionMode = "immediate" }
      }

      primary_package {
        package_id           = "${var.project_k8s___helm_step_deploy_a_helm_chart_packageid}"
        acquisition_location = "Server"
        feed_id              = "${data.octopusdeploy_feeds.feed_octopus_server__built_in_.feeds[0].id}"
        properties           = { SelectionMode = "immediate" }
      }

      features = []
    }

    properties   = {}
    target_roles = ["octopetshop-web"]
  }
  step {
    condition           = "Success"
    name                = "Jira - Add comment to task - API Token"
    package_requirement = "LetOctopusDecide"
    start_trigger       = "StartAfterPrevious"

    action {
      action_type                        = "Octopus.Script"
      name                               = "Jira - Add comment to task - API Token"
      condition                          = "Success"
      run_on_server                      = true
      is_disabled                        = false
      can_be_used_for_project_versioning = false
      is_required                        = false
      worker_pool_id                     = "${data.octopusdeploy_worker_pools.workerpool_hosted_windows.worker_pools[0].id}"
      properties                         = {
        "Octopus.Action.Template.Id" = "ActionTemplates-3682"
        "Octopus.Action.Template.Version" = "${values(data.external.steptemplate_jira___add_comment_to_task___api_token_versions.result)[0]}"
        "Octopus.Action.RunOnServer" = "true"
        "Octopus.Action.Script.ScriptSource" = "Inline"
        "Octopus.Action.Script.Syntax" = "PowerShell"
        "Octopus.Action.Script.ScriptBody" = "$ErrorActionPreference = \"Stop\"\n[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12\n\n$uri = $OctopusParameters[\"jira.comment.url\"]\n$issueKey = $OctopusParameters[\"jira.comment.issuekey\"]\n$comment = $OctopusParameters[\"jira.comment.text\"]\n$email = $OctopusParameters[\"jira.comment.email\"]\n$apiToken = $OctopusParameters[\"jira.comment.apitoken\"]\n\nif ([string]::IsNullOrWhitespace($uri)) {\n    throw \"Missing parameter value for 'jira.comment.url'\"\n}\nif ([string]::IsNullOrWhitespace($issueKey)) {\n    throw \"Missing parameter value for 'jira.comment.issuekey'\"\n}\nif ([string]::IsNullOrWhitespace($comment)) {\n    throw \"Missing parameter value for 'jira.comment.text'\"\n}\nif ([string]::IsNullOrWhitespace($email)) {\n    throw \"Missing parameter value for 'jira.comment.email'\"\n}\nif ([string]::IsNullOrWhitespace($apiToken)) {\n    throw \"Missing parameter value for 'jira.comment.apitoken'\"\n}\n\nfunction Create-Uri {\n    Param (\n        $BaseUri,\n        $ChildUri\n    )\n\n    if ([string]::IsNullOrWhitespace($BaseUri)) {\n        throw \"BaseUri is null or empty!\"\n    }\n    if ([string]::IsNullOrWhitespace($ChildUri)) {\n        throw \"ChildUri is null or empty!\"\n    }\n    $CombinedUri = \"$($BaseUri.TrimEnd(\"/\"))/$($ChildUri.TrimStart(\"/\"))\"\n    return New-Object -TypeName System.Uri $CombinedUri\n}\n\nfunction Jira-ExecuteApi {\n    Param (\n        [Uri]$Query,\n        [string]$Body,\n        [string]$Email,\n        [string]$ApiToken\n    );\n\n    Write-Output \"Posting to JIRA API $($Query.AbsoluteUri)\"\n\n    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((\"{0}:{1}\" -f $Email, $ApiToken)))\n    $headers = @{\n        Authorization = (\"Basic {0}\" -f $base64AuthInfo)\n        \"Content-Type\" = \"application/json\"\n    }\n\n    Invoke-RestMethod -Uri $Query -Headers $headers -UseBasicParsing -Body $Body -Method Post\n}\n\nfunction Jira-AddComment {\n    Param (\n        [string]$BaseUri,\n        [string]$IssueKey,\n        [string]$Email,\n        [string]$ApiToken,\n        [string]$Comment\n    );\n\n    $query = \"$BaseUri/rest/api/2/issue/$IssueKey/comment\"\n    $uri = [System.Uri] $query\n    $body = \"{ \"\"body\"\": \"\"$Comment\"\" }\"\n\n    Jira-ExecuteApi -Query $uri -Body $body -Email $Email -ApiToken $ApiToken\n}\n\nWrite-Output \"JIRA - Add Comment\"\nWrite-Output \"  JIRA URL      : $uri\"\nWrite-Output \"  Issue Key     : $issueKey\"\nWrite-Output \"  Comment       : $comment\"\nWrite-Output \"  Email         : $email\"\n\ntry {\n    Jira-AddComment -BaseUri $uri -IssueKey $issueKey -Comment $comment -Email $email -ApiToken $apiToken\n    Write-Output \"Added comment to JIRA issue: $issueKey\"\n}\ncatch {\n    Write-Error \"An error occurred while attempting to add a comment to the JIRA issue: $($_.Exception)\"\n}"
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
  depends_on = []
}
