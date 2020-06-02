provider "vsphere" {
  user           = "administrator@ktz.lan"
  password       = "supersecretpassword"
  vsphere_server = "192.168.1.240"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "ktzdc"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "ktzcluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "mx1tb" {
  name          = "mx1tb"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "RHCOS43" {
  name          = "RHCOS43"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "nvme500" {
  name          = "nvme500"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "bootstrap_mac" {
    description = "OCP 4 Bootstrap MAC Address"
    type        = string
    default     = "00:50:56:b1:c7:ae"
}

variable "bootstrap_ignition_url" {
    #base64string
    default = "ewogICJpZ25pdGlvbiI6IHsKICAgICJjb25maWciOiB7CiAgICAgICJhcHBlbmQiOiBbCiAgICAgICAgewogICAgICAgICAgInNvdXJjZSI6ICJodHRwczovL2t0ei5ueWMzLmRpZ2l0YWxvY2VhbnNwYWNlcy5jb20vYm9vdHN0cmFwLmlnbiIsCiAgICAgICAgICAidmVyaWZpY2F0aW9uIjoge30KICAgICAgICB9CiAgICAgIF0KICAgIH0sCiAgICAidGltZW91dHMiOiB7fSwKICAgICJ2ZXJzaW9uIjogIjIuMS4wIgogIH0sCiAgIm5ldHdvcmtkIjoge30sCiAgInBhc3N3ZCI6IHt9LAogICJzdG9yYWdlIjoge30sCiAgInN5c3RlbWQiOiB7fQp9"
}