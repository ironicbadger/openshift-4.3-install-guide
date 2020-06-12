resource "vsphere_virtual_machine" "masters" {
  name             = "ocp43.master${count.index + 1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.nvme500.id}"
  folder           = "awesomo/redhat/ocp43"
  count            = length(var.master_macs)
  enable_disk_uuid = "true"

  num_cpus = 4
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.RHCOS43.guest_id}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.RHCOS43.network_interface_types[0]}"
    use_static_mac = true
    mac_address = "${var.master_macs[count.index]}"
  }

  disk {
    label            = "disk0"
    size             = "40"
    thin_provisioned = "${data.vsphere_virtual_machine.RHCOS43.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.RHCOS43.id}"
  }

  vapp {
    properties = {
    "guestinfo.ignition.config.data"          = "${var.master_ignition_url}"
    "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }
}