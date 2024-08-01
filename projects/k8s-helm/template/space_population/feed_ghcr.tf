data "octopusdeploy_feeds" "feed_ghcr" {
  feed_type    = "Docker"
  ids          = null
  partial_name = "GHCR"
  skip         = 0
  take         = 1
  lifecycle {
    postcondition {
      error_message = "Failed to resolve a feed called \"GHCR\". This resource must exist in the space before this Terraform configuration is applied."
      condition     = length(self.feeds) != 0
    }
  }
}
