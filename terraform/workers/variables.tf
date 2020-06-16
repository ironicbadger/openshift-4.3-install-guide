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
    default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb"]
    #default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb", "00:50:56:b1:c7:cc"]
}

variable "worker_ignition_url" {
    #base64string
    default = "eyJpZ25pdGlvbiI6eyJjb25maWciOnsiYXBwZW5kIjpbeyJzb3VyY2UiOiJodHRwczovL2FwaS1pbnQub2NwNC5rdHoubGFuOjIyNjIzL2NvbmZpZy93b3JrZXIiLCJ2ZXJpZmljYXRpb24iOnt9fV19LCJzZWN1cml0eSI6eyJ0bHMiOnsiY2VydGlmaWNhdGVBdXRob3JpdGllcyI6W3sic291cmNlIjoiZGF0YTp0ZXh0L3BsYWluO2NoYXJzZXQ9dXRmLTg7YmFzZTY0LExTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJGUkVORFFXWnBaMEYzU1VKQlowbEpTbE00Y0dwa2J6VlpSakIzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkS2FrVlRUVUpCUjBFeFZVVUtRM2hOU21JelFteGliazV2WVZkYU1FMVNRWGRFWjFsRVZsRlJSRVYzWkhsaU1qa3dURmRPYUUxQ05GaEVWRWwzVFVSWmVFNVVSVEpPVkZWNFRteHZXQXBFVkUxM1RVUlplRTE2UlRKT1ZGVjRUbXh2ZDBwcVJWTk5Ra0ZIUVRGVlJVTjRUVXBpTTBKc1ltNU9iMkZYV2pCTlVrRjNSR2RaUkZaUlVVUkZkMlI1Q21JeU9UQk1WMDVvVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUYxYWtKbFduVmFhVk13WkU0S1pHdzFhMWwyVG5KRFFVaHJUbmcxU2poaWNYY3JVREZYY1ZaWWRIaDVhemt2U1hwdFdUTnFkbVpJVTFCV1ZrVTNiMDl5VkZsMlVsbFZVRUZxYTB3M013cG1TRTlNZHpsNmNuRjFiV1ZWTm5VcmRtWktLMkpQZW1Gb1pWWjJZekZqYVdsR1dXRjVWUzh3U2tWdkwyZElUQzlXYkVGNE1FVnNlbk0wV2s1WE9HaExDbEI0Y1ZRemNsUkNVblZoVld4RmIxUk9Va2wwU1U5VGN6Y3JRVWgwWVhkWGQwVkhNSHAyVUc5dFQyVTVUbEZtTmpGdmFYSTVSRWgzWlV3eWNEaGpjelFLWWtNeEwzY3dXbGhxYm5GRVlqRTFUMEY0WjBVelVrOUtVSFowUVRkVE4xQkhSVTFUZW1WSVlUTm1SMFY1WVVWTlIxUjNiV3hyVFZkNFdHeHJLMmMzV2dwMWNVTlRRVE5FTlN0elQwaGpVVWxuZFRaUWJYQm1RVXRqTm1KRlNUbFFja1JOWldad2NHZzNOWEpUY0ROVUswVkxWVlpTTDBaQlRVY3ZLMGxuTmtaS0NrOVpabU5GU1cxT2MzZEpSRUZSUVVKdk1FbDNVVVJCVDBKblRsWklVVGhDUVdZNFJVSkJUVU5CY1ZGM1JIZFpSRlpTTUZSQlVVZ3ZRa0ZWZDBGM1JVSUtMM3BCWkVKblRsWklVVFJGUm1kUlZYTmhNMlZIYjFGemVUSlNVbHBQY2t0WU1uQm1TR1J2UlZwd05IZEVVVmxLUzI5YVNXaDJZMDVCVVVWTVFsRkJSQXBuWjBWQ1FVWTVhR0ZFUjBGM2EyMXphV0lyUTJSR1QweElURmN5VEVSSWExcFBRVTFoVEdneE1HbFRNME5TZUd0dFkyVldlRFV5VFZweFNVZEpiRFZrQ2s5V09UVnJRWEZMVTBsT1UyRjJhVXBYVTNOcWFUUkRSMFJRY1VZdmNXSlljWEF2ZVhKcGRYTjJSRzloY201cGMzWm5PRnB3VEc0clJISkxTakZJU0VFS1kzTmtUMnBPVldJeU0yOTRaRkp1YjJGSVp6bDJPRnByTUU1NlQwcGxVR3RRVFRaWVYySXhLME5FU0hoYVdWSlBUbmt2ZEROaE5GWjNaak5rTlhSSmFBcDFjSEJqYlVjek5VdEZTVUpITTNoSE1UTm1NVmROYmpFM2JFdGFiWGxIZDJaM1REVjFSemR1TjFoa1oyWXJhazV4YjI1T1UyZFNZMHBGYkc5M2VXaEpDbTlNVG5WdlpYUXpaMjUzZG05WWJqaHNOSFpqUTBkVU5IRmxXRTVSWjJGU1QzcFhiMjkwVDA5UGJuaDNUMGRhVVVsV1prMXZLek54UTIxWGFtbGhNRlVLVDJkV2RVTmhVMUJrTmk5VVFYUmthV2MxVFRGU1pIZDBSMUJuUFFvdExTMHRMVVZPUkNCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2c9PSIsInZlcmlmaWNhdGlvbiI6e319XX19LCJ0aW1lb3V0cyI6e30sInZlcnNpb24iOiIyLjIuMCJ9LCJuZXR3b3JrZCI6e30sInBhc3N3ZCI6e30sInN0b3JhZ2UiOnt9LCJzeXN0ZW1kIjp7fX0="
}
