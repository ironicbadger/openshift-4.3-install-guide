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


data "vsphere_virtual_machine" "RHCOS43" {
  name          = "RHCOS43"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "master_macs" {
    description = "OCP 4 Master MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:c7:ba", "00:50:56:b1:c7:bb", "00:50:56:b1:c7:bc"]
}

variable "master_ignition_url" {
    #base64string
    default = "eyJpZ25pdGlvbiI6eyJjb25maWciOnsiYXBwZW5kIjpbeyJzb3VyY2UiOiJodHRwczovL2FwaS1pbnQub2NwNC5rdHoubGFuOjIyNjIzL2NvbmZpZy9tYXN0ZXIiLCJ2ZXJpZmljYXRpb24iOnt9fV19LCJzZWN1cml0eSI6eyJ0bHMiOnsiY2VydGlmaWNhdGVBdXRob3JpdGllcyI6W3sic291cmNlIjoiZGF0YTp0ZXh0L3BsYWluO2NoYXJzZXQ9dXRmLTg7YmFzZTY0LExTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJGUkVORFFXWnBaMEYzU1VKQlowbEpTa3hLU0VSbmJrbzRaSGQzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkS2FrVlRUVUpCUjBFeFZVVUtRM2hOU21JelFteGliazV2WVZkYU1FMVNRWGRFWjFsRVZsRlJSRVYzWkhsaU1qa3dURmRPYUUxQ05GaEVWRWwzVFVSWmVFMXFSVEJOZW1zd1RteHZXQXBFVkUxM1RVUlplRTFFUlRCTmVtc3dUbXh2ZDBwcVJWTk5Ra0ZIUVRGVlJVTjRUVXBpTTBKc1ltNU9iMkZYV2pCTlVrRjNSR2RaUkZaUlVVUkZkMlI1Q21JeU9UQk1WMDVvVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUY0ZUhGVFdtSXJha0pvZWs4S1RIWTFiRGcxWTFkNGFteHhaMVF6V1dwalMwbFdVSEJUSzFoUE1HcGtiV0poWVVaU05FdFpVR3hJWVZwalRYaFNRVWxhUlVwUVlWWktialFyY2xOcFZBcGtiMmR0VlZOcVFWRnpPVWhpYm1SR2RtbHZjMnRuVTNSbVVHbEpTRnBFYjFwTllqQXpSSEZJYUROd1dqbFZOM2RUTUZjMVpsaHhSa0pSVkRGV1Z6bHpDak56T1RkUWJrOVJiM3A2V2xJd1ZubFNWMGw0UjFacVdXVmlMMEYzZDI1TWJtOXJNMGw1TlRWMVFtZGxiVFJpYVM5TlduSnBWQ3R1VVVaT1pHSkpRbmtLUlVSRldYZzJRMkZ3ZDJSbGNFMU5XbGd5U1doc2VqVkhlR2R5TkZvd2VtNDBiMlkxUldOTWNuSktWbXh3WWpRelFXVkdWVzgyYzFac01XeDNaRmhpTHdwa05rUjVNemxpTjNwb1pHbEVTVEpSUVhORVFtSTVOVmwxUkhkeGJEWk9Zak16ZGtaTlRUbFBURVpwTm05bFJIQmhOa1ZIT0dwT05Fc3Zja2hMYWtzeUNtcFNURVUwZFZKck1IZEpSRUZSUVVKdk1FbDNVVVJCVDBKblRsWklVVGhDUVdZNFJVSkJUVU5CY1ZGM1JIZFpSRlpTTUZSQlVVZ3ZRa0ZWZDBGM1JVSUtMM3BCWkVKblRsWklVVFJGUm1kUlZXcHhiRk50TDI5blpERTNSblJCV0hVM1JsTk5SakVyWmtVdlozZEVVVmxLUzI5YVNXaDJZMDVCVVVWTVFsRkJSQXBuWjBWQ1FVcFZTV3hXYm1WR1ZFVkpiSGcwZFhWQ2JrOVBTREJsVW1JMk1FRnZjSFUyZUhRek5HMXdXalkyUlRsQlJFZHJUa3BDU21WQ2N6TllXR2N4Q25aWUsweFliMGxNZDBsM2VqRXpVWFZOWTNZMGJ6Vk1PR0pKVXl0NE0xTm9lVU5RYjBsdlN6TXdTM1Y2UWxWRVlrRkpaMnhCVlhaSlUzQmhSbGhVTDJ3S1FYcDFObWwwVkdKWWJVVlNiREJ2VjJwYVEyVmhaV1pKUkdjNE5XVkNSakZOUlM5alYyVnplVmRGV1hSWlNUaHpibFZ5YkhsRFR6STNUelpLTjNFclNBcGxXa2RYVTFCMFFteFNWMVkxS3preVFYWjBlV00xVTIxdWJUSlljR1JCUWswd1ZIaFpPVkpoVm1OMVRHVjNVamhaYTIxeWJtUTRZa1FyV2xnNVZubGpDbEZNTjFGMFdtNVpOMGt6UzJsRk0xcDZkVTlYWTFsaVlXZEtVRk42U1ZsRmNuaEtVMlZsTTNkUVNsWldOMHRwTlVNeU1sRm1jMmRzY0hCTEx6TTJORVFLVVZVM1RETnlSRWhFZFZkWmRVaFFhRVZ4UlhoWEwxTjFZemhqUFFvdExTMHRMVVZPUkNCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2c9PSIsInZlcmlmaWNhdGlvbiI6e319XX19LCJ0aW1lb3V0cyI6e30sInZlcnNpb24iOiIyLjIuMCJ9LCJuZXR3b3JrZCI6e30sInBhc3N3ZCI6e30sInN0b3JhZ2UiOnt9LCJzeXN0ZW1kIjp7fX0="
}