terraform {

  required_providers {
    octopusdeploy = { source = "OctopusDeployLabs/octopusdeploy", version = "0.21.1" }
  }

  backend "s3" {
  }

  required_version = ">= 1.6.0"
}

provider "octopusdeploy" {
  address  = trimspace(var.octopus_server)
  api_key  = trimspace(var.octopus_apikey)
  space_id = trimspace(var.octopus_space_id)
}

module "template_project" {
  source = "../../template/space_population"
  project_k8s_helm_template_name = var.project_name
  k8s___helm_project_packagename_1 = "octopusdeploylabs/octotesting"
}

variable "octopus_server" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The URL of the Octopus server e.g. https://myinstance.octopus.app."
}
variable "octopus_apikey" {
  type        = string
  nullable    = false
  sensitive   = true
  description = "The API key used to access the Octopus server. See https://octopus.com/docs/octopus-rest-api/how-to-create-an-api-key for details on creating an API key."
}
variable "octopus_space_id" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The ID of the Octopus space to populate."
}
variable "project_name" {
  type        = string
  nullable    = false
  sensitive   = false
  description = "The name of the project exported from K8s Helm Template"
  default     = "K8s - Helm"
}
