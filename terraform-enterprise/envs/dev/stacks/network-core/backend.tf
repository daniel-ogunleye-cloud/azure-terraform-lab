terraform {
  cloud {
    organization = "daniel-ogunleye-cloud"

    workspaces {
      name = "network-core"
    }
  }
}
