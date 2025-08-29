output "user_credentials" {
  sensitive = true
  value = {
    for user, pw in random_password.user_passwords :
    user => {
      username = user
      password = pw.result
      database = split("_", user)[0]
    }
  }
}