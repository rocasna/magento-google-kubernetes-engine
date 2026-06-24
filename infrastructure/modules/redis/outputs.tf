# Name Redis
output "redis_instance_name" {
  value = google_redis_instance.cache.name
}
