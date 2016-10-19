---
layout: "terraform"
page_title: "Terraform: terraform_remote_state"
sidebar_current: "docs-terraform-datasource-remote-state"
description: |-
  Accesses state meta data from a remote backend.
---

# remote\_state

Retrieves state meta data from a remote backend

## Example Usage

```
data "terraform_remote_state" "vpc" {
    backend = "atlas"
    config {
        name = "hashicorp/vpc-prod"
    }
}

resource "aws_instance" "foo" {
    # ...
    subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
}
```

## Argument Reference

The following arguments are supported:

* `backend` - (Required) The remote backend to use.
* `config` - (Optional) The configuration of the remote backend.
 * Remote state config docs can be found [here](https://www.terraform.io/docs/state/remote/atlas.html)

## Attributes Reference

The following attributes are exported:

* `backend` - See Argument Reference above.
* `config` - See Argument Reference above.

In addition, each output in the remote state appears as a top level attribute
on the `terraform_remote_state` resource.
