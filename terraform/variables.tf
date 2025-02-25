variable "region" {
  description = "region"
  sensitive   = true
}

variable "access_key" {
  description = "access_key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "secret_key"
  type        = string
  sensitive   = true
}

variable "vpc_cidr" {
  description = "El bloque CIDR para la VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr1" {
  description = "El bloque CIDR para la primera subred pública"
  default     = "10.0.1.0/24"
}

variable "subnet_cidr2" {
  description = "El bloque CIDR para la segunda subred pública"
  default     = "10.0.2.0/24"
}