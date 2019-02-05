output "vagrant" {
  value = "vagrant ssh"

  depends_on = ["null_resource.vagrant"]
}
