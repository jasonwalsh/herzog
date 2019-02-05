output "vagrant" {
  description = "SSH into a running Vagrant machine"
  value       = "vagrant ssh"

  depends_on = ["null_resource.vagrant"]
}
