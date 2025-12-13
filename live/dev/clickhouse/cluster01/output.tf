output "admin-passwd" {
  value     = random_password.admin-passwd.result
  sensitive = true
  description = "Admin password"
}
