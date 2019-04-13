output "webhook_secret" {
  description = "Webhook secret"
  value       = "${random_id.webhook.*.hex}"
}
