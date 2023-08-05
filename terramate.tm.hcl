terramate {
  required_version = "~> 0.4.0"
  config {
    git {
      default_remote = "origin"
      default_branch = "main"
      check_untracked = false
      check_uncommitted = false
      check_remote = false
    }
  }
}