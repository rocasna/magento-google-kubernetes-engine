resource "google_sql_database_instance" "mysql" {
  name             = "${var.env}-magento-db"
  database_version = "MYSQL_8_4"
  region           = var.region

  settings {
    tier = "db-f1-micro" # La más barata para dev
    edition = "ENTERPRISE"
    
    ip_configuration {
      ipv4_enabled    = false # Privada, solo accesible desde la VPC
      private_network = var.vpc_id
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "magento_db" {
  name     = "magento"
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "users" {
  name     = google_secret_manager_secret_version.secret-version-user.secret_data
  instance = google_sql_database_instance.mysql.name
  host     = "0.0.0.0/0"
  password = google_secret_manager_secret_version.secret-version-pass.secret_data
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "google_secret_manager_secret" "secret-user-db" {
  secret_id = "${var.app}-secret-user-db"

  labels = {
    app = var.app
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret-version-user" {
  secret = google_secret_manager_secret.secret-user-db.id

  secret_data = var.database_user
}

resource "google_secret_manager_secret" "secret-pass-db" {
  secret_id = "${var.app}-secret-pass-db"

  labels = {
    app = var.app
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret-version-pass" {
  secret = google_secret_manager_secret.secret-pass-db.id

  secret_data = random_password.db_password.result
}