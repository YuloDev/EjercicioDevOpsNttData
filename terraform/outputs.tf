output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "ecs_cluster_id" {
  description = "ID del cluster de ECS"
  value       = aws_ecs_cluster.cluster.id
}

output "alb_dns_name" {
  description = "DNS del ALB"
  value       = aws_lb.alb.dns_name
}
