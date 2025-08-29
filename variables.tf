variable "db_host" {
  description = "PostgreSQL host"
  type        = string
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "db_admin_user" {
  description = "Admin user"
  type        = string
}

variable "db_admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}