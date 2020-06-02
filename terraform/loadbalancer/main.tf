resource "vsphere_virtual_machine" "lb" {
  name             = "ocp43.lb"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.mx1tb.id}"
  folder           = "awesomo/redhat/ocp43"
  count            = 1
  
  num_cpus = 2
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.rhel7.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.rhel7.network_interface_types[0]}"
    use_static_mac = true
    mac_address = "${var.lb_mac}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.rhel7.id}"
    customize {
      linux_options{
        host_name = "ocp43-lb"
        domain = "ktz.lan"
      }
      network_interface {}
    }
  }
  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = "${data.vsphere_virtual_machine.rhel7.disks.0.thin_provisioned}"
  }
}