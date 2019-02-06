output "message" {
  description = "SSH connectivity information"
  value       = "ssh ${format("%s@%s", var.ssh_username, element(module.instance.public_dns, 0))}"
}
