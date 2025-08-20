output "yc-user-passwd" {
  value     = random_password.yc-user-passwd.result
  sensitive = true
}

output "github-ci-passwd" {
  value     = random_password.github-ci-passwd.result
  sensitive = true
}
