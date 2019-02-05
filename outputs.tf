output "vagrantfile" {
  description = "The Vagrantfile template"
  value       = "${data.template_file.vagrantfile.rendered}"
}
