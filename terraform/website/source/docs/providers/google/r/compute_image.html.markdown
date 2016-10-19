---
layout: "google"
page_title: "Google: google_compute_image"
sidebar_current: "docs-google-compute-image"
description: |-
  Creates a bootable VM image for Google Compute Engine from an existing tarball.
---

# google\_compute\_image

Creates a bootable VM image resource for Google Compute Engine from an existing
tarball. For more information see [the official documentation](https://cloud.google.com/compute/docs/images) and
[API](https://cloud.google.com/compute/docs/reference/latest/images).


## Example Usage

```js
resource "google_compute_image" "bootable-image" {
  name       = "my-custom-image"
  raw_disk {
    source = "https://storage.googleapis.com/my-bucket/my-disk-image-tarball.tar.gz"
  }
}

resource "google_compute_instance" "vm" {
  name         = "vm-from-custom-image"
  machine_type = "n1-standard-1"
  zone         = "us-east1-c"

  disk {
    image = "${google_compute_image.bootable-image.self_link}"
  }

  network_interface {
	network = "default"
  }
}
```

## Argument Reference

The following arguments are supported:

* `name` - (Required) A unique name for the resource, required by GCE.
    Changing this forces a new resource to be created.

* `raw_disk` - (Required) The raw disk that will be used as the source of
    the image. Changing this forces a new resource to be created.
    Structure is documented below.

The `raw_disk` block supports:

* `source` - (Required) The full Google Cloud Storage URL where the disk
    image is stored.

* `sha1` - (Optional) SHA1 checksum of the source tarball that will be used
    to verify the source before creating the image.

* `container_type` - (Optional) The format used to encode and transmit the
    block device. TAR is the only supported type and is the default.

- - -

* `project` - (Optional) The project in which the resource belongs. If it
    is not provided, the provider project is used.

* `description` - (Optional) The description of the image to be created

* `family` - (Optional) The name of the image family to which this image belongs.

## Attributes Reference

In addition to the arguments listed above, the following computed attributes are
exported:

* `self_link` - The URI of the created resource.
