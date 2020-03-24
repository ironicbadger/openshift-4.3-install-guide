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

data "vsphere_virtual_machine" "rhel7" {
  name          = "rhel7"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "lb_mac" {
    description = "OCP 4 HAProxy MAC Address"
    type        = string
    default     = "00:50:56:b1:ef:ac"
}