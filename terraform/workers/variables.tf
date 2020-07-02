provider "vsphere" {
  user           = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-user"]
  password       = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-password"]
  vsphere_server = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-server"]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
}

data "vsphere_compute_cluster" "cluster" {
  name          = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-cluster"]
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "mx1tb" {
  name          = "mx1tb"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "nvme500" {
  name          = "nvme500"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "RHCOS" {
  name          = "rhcos-4.4.3"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "worker_macs" {
    description = "OCP 4 Worker MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb"]
    #default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb", "00:50:56:b1:c7:cc"]
}

variable "worker_ignition_url" {
    #base64string
    default = "eyJpZ25pdGlvbiI6eyJjb25maWciOnsiYXBwZW5kIjpbeyJzb3VyY2UiOiJodHRwczovL2FwaS1pbnQub2NwNC5rdHoubGFuOjIyNjIzL2NvbmZpZy93b3JrZXIiLCJ2ZXJpZmljYXRpb24iOnt9fV19LCJzZWN1cml0eSI6eyJ0bHMiOnsiY2VydGlmaWNhdGVBdXRob3JpdGllcyI6W3sic291cmNlIjoiZGF0YTp0ZXh0L3BsYWluO2NoYXJzZXQ9dXRmLTg7YmFzZTY0LExTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJGUkVORFFXWnBaMEYzU1VKQlowbEpWVEpLYm0xQlNsWm5ZV3QzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkS2FrVlRUVUpCUjBFeFZVVUtRM2hOU21JelFteGliazV2WVZkYU1FMVNRWGRFWjFsRVZsRlJSRVYzWkhsaU1qa3dURmRPYUUxQ05GaEVWRWwzVFVSamQwMXFSVEJPUkd0NVRVWnZXQXBFVkUxM1RVUlplazFFUlRCT1JHdDVUVVp2ZDBwcVJWTk5Ra0ZIUVRGVlJVTjRUVXBpTTBKc1ltNU9iMkZYV2pCTlVrRjNSR2RaUkZaUlVVUkZkMlI1Q21JeU9UQk1WMDVvVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUUxTTBsd1prOWtiVUZIU0RJS2RFUlhaR1pNVUZkc01tUnplRVppV1Roa1VVVXhNakptUWl0WFJFOTJhVzlsZWtaM1RVcHViMnRyU3pCNlRYQk9aRWRNYlZCd2RVbFRSWFpSYWtGM1VRcFBkMFV6V2tVNFkzTXJOa2xQWkRadVkydG5aakpFWlhKUldFcEpSSHBTU25sUGJVeEJiSEp1U1daaVluQnVkRXRNWlUxMWFVeHViMUV6VVdGeFdXWkNDblJJTmtWaU1WWm5hMnRNTjJrNFYyTkpVVFY2Y20xTU5IUk5lQzhyTUVocGQyWndiMWd6WTJ4TVpIVktZMFJ3THpSUFdqTldZbEJwV0ZkSFVYaDJZV3dLTTFOWldFaElWRWMzUVVKTWNWSkpWV0pFUkZkME0yTkRjMmx2WmtKRk5XbFJkM2t2ZGs4clNXWjBWMGt5UzJoelZ6RnRSbm94ZWxKMlptTk5OM0JMU1FwVGNtUlRNbFJqTUZaclQyTm9LMUZCVFRSck5uaFRjamRXU2tadlpqRk1aWEUyVGtKUVN6QTVNa0ZNVEhGQlEwOXVRM2RTYjJoMk4wOVNVVmRtYjJ0WkNrcHFlVmh3V0hWT1ZsRkpSRUZSUVVKdk1FbDNVVVJCVDBKblRsWklVVGhDUVdZNFJVSkJUVU5CY1ZGM1JIZFpSRlpTTUZSQlVVZ3ZRa0ZWZDBGM1JVSUtMM3BCWkVKblRsWklVVFJGUm1kUlZUWkRRakpaWTFWMVZEY3ZZM0pJZFRoWmNFTndURTlXUmtWaldYZEVVVmxLUzI5YVNXaDJZMDVCVVVWTVFsRkJSQXBuWjBWQ1FVcEZVMVpRVUVSNmNYZE9jbEJhV2xsQmRWWlhWVEZ6YUhoUVpsTmpOblpNY0haYWJtbzVZa1JZT1hGVVdubEthVEJKV0RkTWJVUmxlVmd3Q25ocWJYUmtSRE50YjFjMlpGcFpLMU54ZVVWU2VtdFlSV3hhUjB4aGNGVXlkaTgwY1hOV1IxSnlUa1ZSTkROTmMwNHpka1JMZG1sQ0wyNDBWbTFETkU4S1FsQm1SaXRRZGl0c05YRXJhSGRvZWtSU2FVWndiV1J4WjBoclR6UlBiSGs0UVUwMldrNHdSVTFXUkRKdlMydEphMW8yYURseWVWRmxNMFJSVjB0U01RcFRabUZVVlV3M09WQmhTRmd2ZVVsTGFXcEVZemRaVFVGV1Jta3dUSGhPZVZCVk1tOUZTelJ6YUZKcFduUndiWGhrUkdjd1ZHRlJhMDVSUW5ZM1IwSjZDbU5hZVc1aGQxVnNUamhxYmxKVVdISkVOemxTVW1OemJFNURVREJEYkdWRlNFUTFhSFZUUzBJd2IyNVRiVlpaV0N0UVNVSjZhVFZRYjI0cmJVUTBhMlFLTmsxNFQxcDZSM0pqTms1VE5WbFBSMDg1TlhnemRFOW5MM05OUFFvdExTMHRMVVZPUkNCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2c9PSIsInZlcmlmaWNhdGlvbiI6e319XX19LCJ0aW1lb3V0cyI6e30sInZlcnNpb24iOiIyLjIuMCJ9LCJuZXR3b3JrZCI6e30sInBhc3N3ZCI6e30sInN0b3JhZ2UiOnt9LCJzeXN0ZW1kIjp7fX0="
}
