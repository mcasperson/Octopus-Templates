data "external" "steptemplate_jira___add_comment_to_task___api_token" {
  program = ["pwsh", "-Command", "\n$query = [Console]::In.ReadLine() | ConvertFrom-JSON\n$headers = @{ \"X-Octopus-ApiKey\" = $query.apikey }\n$response = Invoke-WebRequest -Uri \"$($query.server)/api/$($query.spaceid)/actiontemplates?take=10000\" -Method GET -Headers $headers\n$keyValueResponse = @{}\n$response.content | ConvertFrom-JSON | Select-Object -Expand Items | ? {$_.Name -eq $query.name} | % {$keyValueResponse[$_.Id] = $_.Name} | Out-Null\n$results = $keyValueResponse | ConvertTo-JSON -Depth 100\nWrite-Host $results"]
  query   = { apikey = "${var.octopus_apikey}", name = "Jira - Add comment to task - API Token", server = "${var.octopus_server}", spaceid = "${var.octopus_space_id}" }
  lifecycle {
    postcondition {
      error_message = "Failed to resolve an step template called \"Jira - Add comment to task - API Token\". This resource must exist in the space before this Terraform configuration is applied."
      condition     = length(keys(self.result)) != 0
    }
  }
}
