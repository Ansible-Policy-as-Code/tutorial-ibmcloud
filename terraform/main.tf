terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.47.0-beta2"
    }
  }
}

provider "ibm" {
  # Configuration options
}

data "ibm_resource_group" "default_group" {
  name = "default"
}

resource "ibm_cloudant" "cloudant" {
  name     = "policy-as-code-cloudant"
  location = "us-south"
  plan     = "lite"
  tags     = ["costcenter:001589"]

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cloudant_database" "cloudant_database" {
  instance_crn  = ibm_cloudant.cloudant.crn
  db            = "policyascode"
}
