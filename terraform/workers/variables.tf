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

variable "worker_macs" {
    description = "OCP 4 Worker MAC Address"
    type        = list(string)
    #default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb"]
    default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb", "00:50:56:b1:c7:cc"]
}

variable "worker_ignition_url" {
    #base64string
    default = "eyJpZ25pdGlvbiI6eyJjb25maWciOnsiYXBwZW5kIjpbeyJzb3VyY2UiOiJodHRwczovL2FwaS1pbnQub2NwNC5rdHoubGFuOjIyNjIzL2NvbmZpZy93b3JrZXIiLCJ2ZXJpZmljYXRpb24iOnt9fV19LCJzZWN1cml0eSI6eyJ0bHMiOnsiY2VydGlmaWNhdGVBdXRob3JpdGllcyI6W3sic291cmNlIjoiZGF0YTp0ZXh0L3BsYWluO2NoYXJzZXQ9dXRmLTg7YmFzZTY0LExTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJGUkVORFFXWnBaMEYzU1VKQlowbEpVbGRWWW5kVFIyMXNUVTEzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkS2FrVlRUVUpCUjBFeFZVVUtRM2hOU21JelFteGliazV2WVZkYU1FMVNRWGRFWjFsRVZsRlJSRVYzWkhsaU1qa3dURmRPYUUxQ05GaEVWRWwzVFVSWmVFMXFTWGhOZWxsNFQxWnZXQXBFVkUxM1RVUlplRTFFU1hoTmVsbDRUMVp2ZDBwcVJWTk5Ra0ZIUVRGVlJVTjRUVXBpTTBKc1ltNU9iMkZYV2pCTlVrRjNSR2RaUkZaUlVVUkZkMlI1Q21JeU9UQk1WMDVvVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUYxUjNZMk1sZDRhMnh4WjNJS01UUk9hakk1TDBkc2RtUjRXWE41TlRJelIybFJNRGhFY2xwc1puQmpXRXBJWmxVM2NVbDJjMHh3Y2lzNWF5dGFkR1JRYkdJcmVtMTVlSG96VG10cVRBcG5heXRMVlVocE9FTjVTMm8yUVZOWmJtZGFZemcwYVhZMGJ6UTNhalpLY0VWNFN5c3hiRTlZYzFod1JYRTBiM2w1Y1VwR2RWQXllbGhZUmpCTGFIQlJDbWxOUVhZek9FaG5WMVJJWml0M1lXZFBVamhvYVRaUk4zTjRURE0yY3l0WksweDNjRE5UYjNveVVDdGxZMVZ0UldKdVF6TnRZbTFDTmxscE1FMTBLMUVLTlZwa1NGaDZNekZrTHpSaGFtbG5URUZ1U1hoR1dsWjFORVl5ZFhKSllrZHdSbWN6ZGxrclkwbHRNRzlpYmswNFEzZEVLeko2Y3pobE1FdFVWazFWZEFwWVYzcG1jR2xZZDFKWmNHeGhNVFZqTTNsU016TnBjWGc1Tld4eGRWbDFOemRaYkhsMmJWbzVWRzV5TTBGT1JqTmxVbFUyZGxKSFpGUlZWbHBSTnpobENqVnZla0pCVjFCRE1IZEpSRUZSUVVKdk1FbDNVVVJCVDBKblRsWklVVGhDUVdZNFJVSkJUVU5CY1ZGM1JIZFpSRlpTTUZSQlVVZ3ZRa0ZWZDBGM1JVSUtMM3BCWkVKblRsWklVVFJGUm1kUlZVdHNjMWhRY25KSVRqY3ZlaXMxYjJ4YVV6aHBiMUZvU1hsMVJYZEVVVmxLUzI5YVNXaDJZMDVCVVVWTVFsRkJSQXBuWjBWQ1FVVjZkbmRETkZNNGNGTkhNRVJNTUU5bGJUQnpNVzAxTlRaTFVWWmFkSEpwTWxscWJUZEpkazFLTDFCdE1tUm1MekJWZW5oR09VbzBibE5LQ2xCeFdtSm9ZMjFCV0VwMFptZHhhVzFuVm1wQ1NHNHJUbGxFWkhKMlpXVldVbWx5Y2tacEx5dERaV3RDUVVkbmRIUkJkbEE0ZDNWWmVHSkVLemczUWpRS2FVWkNNRWhKYjJKYVlWb3djbFo2YWxWb1JrTlJTR05PZURBMGRHSXJWVWxVZUhKRWVXRTViRXhZVkVWT1NUVXdibGhxYUVGUmNuaFBVbGhITTBSMU9BcEVTMnBXTWt0S1pqQk1jWGM0YjNKb05qQjFlRkJ2TmxoUGRVaGxSbEJVUzJobVVubFlOR1paZEdKVlkxSTFNV2xIWlhJelN6Wk5VblIwTVV4cU9XazJDbHBOYXpsb1RUSlFUbFJuVkVGbGRtWjRZVmR4UmpCQmFYSkJhVmc1ZG1KRE5URk5LMUZsYlZOVUsxbHhlWGxZV2xOUWEwc3lTbU56WmpFMVFYTkhVSFFLVUU0eldWaE5SbVV4Ym1vd1JVTnhMMEl4YTFSNlRrMTBabUpKUFFvdExTMHRMVVZPUkNCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2c9PSIsInZlcmlmaWNhdGlvbiI6e319XX19LCJ0aW1lb3V0cyI6e30sInZlcnNpb24iOiIyLjIuMCJ9LCJuZXR3b3JrZCI6e30sInBhc3N3ZCI6e30sInN0b3JhZ2UiOnt9LCJzeXN0ZW1kIjp7fX0="
}
