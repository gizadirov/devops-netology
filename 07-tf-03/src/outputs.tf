output "hosts" {
  value = [for e in local.webservers : { fqdn = e.fqdn, id = e.id, name = e.name, }]
}
