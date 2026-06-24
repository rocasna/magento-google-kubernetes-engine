# Salidas de la base de datos MySQL
output "db_instance_name" {
  value = google_sql_database_instance.mysql.name
}

output "db_name" {
  value = google_sql_database.magento_db.name
}

output "secret_user_db" {
  value = google_secret_manager_secret.secret-user-db
}

output "user_db" {
  value = google_sql_user.users.id
}