terraform {
  cloud {
    organization = "daniel-ogunleye-cloud"

    workspaces {
      name = "security-dev"
    }
  }
}
