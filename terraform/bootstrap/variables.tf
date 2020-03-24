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
    default = "ewogICJpZ25pdGlvbiI6IHsKICAgICJjb25maWciOiB7CiAgICAgICJhcHBlbmQiOiBbCiAgICAgICAgewogICAgICAgICAgInNvdXJjZSI6ICJodHRwOi8vMTkyLjE2OC4xLjE2MDo4MDgwL2lnbml0aW9uL2Jvb3RzdHJhcC5pZ24iLAogICAgICAgICAgInZlcmlmaWNhdGlvbiI6IHt9CiAgICAgICAgfQogICAgICBdCiAgICB9LAogICAgInRpbWVvdXRzIjoge30sCiAgICAidmVyc2lvbiI6ICIyLjEuMCIKICB9LAogICJuZXR3b3JrZCI6IHt9LAogICJwYXNzd2QiOiB7fSwKICAic3RvcmFnZSI6IHt9LAogICJzeXN0ZW1kIjoge30KfQ=="
}