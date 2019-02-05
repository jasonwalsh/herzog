output "vagrantfile" {
  value = "${data.template_file.vagrantfile.rendered}"
}
