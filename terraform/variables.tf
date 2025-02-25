variable "region" {
  description = "La región de AWS"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "El bloque CIDR para la VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "El bloque CIDR para la subred pública"
  default     = "10.0.1.0/24"
}

variable "ecs_cpu" {
  description = "La cantidad de CPU para la tarea ECS"
  default     = "256"
}

variable "ecs_memory" {
  description = "La cantidad de memoria para la tarea ECS"
  default     = "512"
}

variable "image_tag" {
  description = "La etiqueta de la imagen Docker en ECR"
  default     = "latest"
}
