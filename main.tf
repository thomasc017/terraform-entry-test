terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.21.0"
    }
  }

  required_version = ">= 1.0"
}

provider "postgresql" {
  host            = var.db_host
  port            = var.db_port
  username        = var.db_user
  password        = var.db_password
  sslmode         = "disable"
  connect_timeout = 15
}

resource "postgresql_database" "db1" {
  name = "database_one"
}

resource "postgresql_database" "db2" {
  name = "database_two"
}

resource "postgresql_database" "db3" {
  name = "database_three"
}
