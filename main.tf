terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "postgresql" {
  host            = var.db_host
  port            = var.db_port
  username        = var.db_admin_user
  password        = var.db_admin_password
  sslmode         = "disable"
  connect_timeout = 15
}

locals {
  workspace      = terraform.workspace
  databases    = ["db1", "db2", "db3"]
  users_per_db = ["user1", "user2"]

  # Flattened list of fully qualified usernames like db1_dev_user1
  full_users = flatten([
    for db in local.databases : [
      for user in local.users_per_db : {
        db       = "${db}_${local.workspace}"
        username = "${db}_${local.workspace}_${user}"
      }
    ]
  ])
}


# Create the databases with workspace suffix
resource "postgresql_database" "databases" {
  for_each = toset(local.databases)
  name = "${each.key}_${local.workspace}"
}

# Generate a random password for each user
resource "random_password" "user_passwords" {
  for_each = toset(local.users_per_db)

  length  = 16
  special = true
}

# Create users with their passwords
resource "postgresql_role" "users" {
  for_each = random_password.user_passwords

  name     = each.key
  password = each.value.result
  login    = true
}

# Grant admin-level privileges on the database
resource "postgresql_grant" "db_admin_grants" {
  for_each = random_password.user_passwords

  database    = split("_", each.key)[0]
  role        = each.key
  object_type = "database"
  privileges  = ["ALL"]
}

# Create a random password for the read-only user
resource "random_password" "readonly_password" {
  length  = 16
  special = true
}

# Create the read-only user
resource "postgresql_role" "readonly_user" {
  name     = "readonly_user"
  login    = true
  password = random_password.readonly_password.result
}

# Allow CONNECT to each database
resource "postgresql_grant" "readonly_db_connect" {
  for_each = toset(local.databases)

  database    = each.key
  role        = postgresql_role.readonly_user.name
  object_type = "database"
  privileges  = ["CONNECT"]
}
