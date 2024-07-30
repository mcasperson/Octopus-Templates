data "octopusdeploy_channels" "channel_k8s_helm_template_default" {
  ids          = []
  partial_name = "Default"
  skip         = 0
  take         = 1
}
