data "octopusdeploy_feeds" "feed_echo" {
  feed_type    = "Helm"
  ids          = null
  partial_name = "Echo"
  skip         = 0
  take         = 1
  lifecycle {
    postcondition {
      error_message = "Failed to resolve a feed called \"Echo\". This resource must exist in the space before this Terraform configuration is applied."
      condition     = length(self.feeds) != 0
    }
  }
}
