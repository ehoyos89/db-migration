variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of key pair to use for bastion host"
  type        = string
  default     = "tu-llave-aws" # Cambia esto por el nombre de tu key pair en AWS
}
  
