terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rpalladino"

    workspaces {
      name = "roccopalladino-dev"
    }
  }
}
