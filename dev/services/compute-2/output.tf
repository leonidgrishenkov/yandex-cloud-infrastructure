output "yc-user-passwd" {
  value     = random_password.yc-user-passwd.result
  sensitive = true
}
