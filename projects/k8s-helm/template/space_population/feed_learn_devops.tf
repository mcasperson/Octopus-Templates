data "octopusdeploy_feeds" "feed_learn_devops" {
  feed_type    = "Helm"
  ids          = null
  partial_name = "Learn DevOps"
  skip         = 0
  take         = 1
  lifecycle {
    postcondition {
      error_message = "Failed to resolve a feed called \"Learn DevOps\". This resource must exist in the space before this Terraform configuration is applied."
      condition     = length(self.feeds) != 0
    }
  }
}
