output "yc_user_passwd" {
  value     = random_password.yc_user_passwd.result
  sensitive = true
}
