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

variable "master_macs" {
    description = "OCP 4 Master MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:c7:ba", "00:50:56:b1:c7:bb", "00:50:56:b1:c7:bc"]
}

variable "master_ignition_url" {
    #base64string
    default = "eyJpZ25pdGlvbiI6eyJjb25maWciOnsiYXBwZW5kIjpbeyJzb3VyY2UiOiJodHRwczovL2FwaS1pbnQub2NwNC5rdHoubGFuOjIyNjIzL2NvbmZpZy9tYXN0ZXIiLCJ2ZXJpZmljYXRpb24iOnt9fV19LCJzZWN1cml0eSI6eyJ0bHMiOnsiY2VydGlmaWNhdGVBdXRob3JpdGllcyI6W3sic291cmNlIjoiZGF0YTp0ZXh0L3BsYWluO2NoYXJzZXQ9dXRmLTg7YmFzZTY0LExTMHRMUzFDUlVkSlRpQkRSVkpVU1VaSlEwRlVSUzB0TFMwdENrMUpTVVJGUkVORFFXWnBaMEYzU1VKQlowbEpXa2xNV205SFZUUlVlbTkzUkZGWlNrdHZXa2xvZG1OT1FWRkZURUpSUVhkS2FrVlRUVUpCUjBFeFZVVUtRM2hOU21JelFteGliazV2WVZkYU1FMVNRWGRFWjFsRVZsRlJSRVYzWkhsaU1qa3dURmRPYUUxQ05GaEVWRWwzVFVSTmVVNUVSVE5OUkVsNVRURnZXQXBFVkUxM1RVUk5lVTFxUlROTlJFbDVUVEZ2ZDBwcVJWTk5Ra0ZIUVRGVlJVTjRUVXBpTTBKc1ltNU9iMkZYV2pCTlVrRjNSR2RaUkZaUlVVUkZkMlI1Q21JeU9UQk1WMDVvVFVsSlFrbHFRVTVDWjJ0eGFHdHBSemwzTUVKQlVVVkdRVUZQUTBGUk9FRk5TVWxDUTJkTFEwRlJSVUU0UnpCeEx6Y3pkVlp1VWswS2VuTTNaV2xYWm5aaFJtaGhiM2RPWkVwWFVHSTVhMGxoSzBoVE1ETjJkVEJZY1d0T1dWaDNha2xLWW1sNFZFOTZUVWgyY1ZodFVGZ3JkM05OZFZWNFJRcDNSRVpLTUhocU1sSjVUblZ3VkhnMVFsWjJkVmhIZEdvM1luTkxaSFpqZFhOelVISk1NRmxqVUhnME9WaFdaa2xaZWpWSldqUnZiVEZLTkVKcVJGVjNDbUo0TlZkME5GVXJhbmd6WVhndmEzRklXRTVrT0ZGU1dYUjRUME5xUTNOS1UzUlpURTEwT1hoU1VHaENUbmhEVTB4M1ExbEJjbXhPWkZaMFEzaEtXRzRLV1RaMGFXRkZTa1ZqWTJocU1ESnpUM056TWtNMVYzQkhTaXR0YjFScVZVUmphbXczZDFNNFRYRjZhR2syYjJJeFVWUmlaa1J4YldGMGJVSkRjRzFCTndwd2RIZENZa1l4YkhWT1pXMUtaM1EyYVhSa2VtRk9iRnByWW1wcGFUSm9TVTg0Y0c4elRWQnhNMGxFVldNMmNGRXhVRTVPWjFoa1dqaDNlakFyY1cxMENqbE9ORFZFTDIwclRIZEpSRUZSUVVKdk1FbDNVVVJCVDBKblRsWklVVGhDUVdZNFJVSkJUVU5CY1ZGM1JIZFpSRlpTTUZSQlVVZ3ZRa0ZWZDBGM1JVSUtMM3BCWkVKblRsWklVVFJGUm1kUlZUWTRPVEY0VTJaRk1UTkxLMVI2TURaaVNYcGlabFJRWm1OVWIzZEVVVmxLUzI5YVNXaDJZMDVCVVVWTVFsRkJSQXBuWjBWQ1FVMVBiSGRDUkhwaGRWQklhME5SZEdaemFqTkxUbGhZVERCck5GZDBNR2xvWTBOdFNUaFdZbGxsWWtsUFNXeFRXVVk0ZFVOalMyMUxPRVUxQ2tFck9IQjNOVmM1Wm5RelJVWTVWR1pSV0UxMldHeDRRWEZTVERKNGJGcHhMMmxyVTAxemRsaFliamxVWW5sWGRXMXJTMGcxZGs1c2MwaDZRVXAyVWtjS056WTJiVzV0TVhBNGFUUkRlRk01YldkNEwybFpjRE5uU1VsVVVWTnFSbUpsUVRKUWNqZHBkM1pLVDFkdFppczRhelI1WjJrNVkyNVhWRGQ0UlhRM2RBcDJVRE4wTW5FeWVXaFhUVmRyV1RSSmVuRXlUV2hOWTNkSU1qWldWMnRqVjFoQlFXVllUMWRJVFhGTk5GbEdOMEpOYkZVd01rNTNTVkVyWTFOVUwxTlhDbkJNVlUxWWJTOVVlVlJLSzJOWFIyVktOVnBvZDNGTVVXOTBOVWRPU1RRNVpDdFRkMWxtYzBONFJFTTJabG8zY0RKQmEySndZV3hRTjAxQ1dWVkRhallLVTAxV2VHcEViVGxoV1N0c05rMVlaMVJwTmxsd1ZURjZMMnBaUFFvdExTMHRMVVZPUkNCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2c9PSIsInZlcmlmaWNhdGlvbiI6e319XX19LCJ0aW1lb3V0cyI6e30sInZlcnNpb24iOiIyLjIuMCJ9LCJuZXR3b3JrZCI6e30sInBhc3N3ZCI6e30sInN0b3JhZ2UiOnt9LCJzeXN0ZW1kIjp7fX0="
}