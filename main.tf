provider "vsphere" {
  user           = "********************"
  password       = "******"
  vsphere_server = "192.168.25.XXX"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datacenter" "dc" {
  name = "rahul-dc"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "rahul-cluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_virtual_machine" "template_from_ovf" {
  name          = "rahul-vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
#test 
# lets add one more test
resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test2"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 10
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template_from_ovf.id}"
  }
}