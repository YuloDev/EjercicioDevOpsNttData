output "ecr_repository_url" {
  description = "URL del repositorio ECR"
  value       = module.ecr.repository_url
}

output "ecs_cluster_name" {
  description = "Nombre del clúster ECS"
  value       = module.ecs.cluster_name
}
