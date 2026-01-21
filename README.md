# Database Migration Project

Sistema de migración de base de datos MySQL utilizando AWS Database Migration Service (DMS) con infraestructura como código mediante Terraform.

## Descripción

Este proyecto facilita la migración de una base de datos MySQL local hacia AWS RDS utilizando DMS. Incluye:

- Entorno local MySQL con Docker Compose
- Infraestructura AWS automatizada con Terraform
- Configuración de VPC, subnets y security groups
- Instancia bastion para acceso seguro
- Replicación DMS para migración de datos

## Estructura del Proyecto

```
db-migration/
├── docker-compose.yml          # MySQL local para desarrollo
├── init-db/                    # Scripts de inicialización
│   ├── 01-create-user.sql     # Creación de usuario
│   └── sample_data.sql        # Datos de ejemplo
├── infra-aws/                 # Infraestructura Terraform
│   ├── main.tf               # Configuración principal
│   ├── vpc.tf                # Red y subnets
│   ├── db.tf                 # RDS MySQL
│   ├── dms.tf                # Database Migration Service
│   ├── bastion.tf            # Servidor bastion
│   ├── sg.tf                 # Security groups
│   ├── iam.tf                # Roles y políticas IAM
│   └── variables.tf          # Variables de configuración
└── LICENSE                   # Licencia MIT
```

## Requisitos Previos

- Docker y Docker Compose
- Terraform >= 1.0
- AWS CLI configurado
- Cuenta AWS con permisos para crear recursos

## Configuración Local

### 1. Levantar Base de Datos Local

```bash
docker-compose up -d
```

Esto creará:
- MySQL 8.0 en puerto 3306
- Base de datos `ecommerce_db`
- Usuario `ec2_user` con permisos completos
- Datos de ejemplo cargados automáticamente

### 2. Verificar Conexión

```bash
mysql -h localhost -u ec2_user -p ecommerce_db
# Password: secure_password
```

## Despliegue en AWS

### 1. Configurar Variables

Edita `infra-aws/variables.tf` con tus valores:

```hcl
variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}
```

### 2. Desplegar Infraestructura

```bash
cd infra-aws
terraform init
terraform plan
terraform apply
```

### 3. Recursos Creados

- **VPC** con subnets públicas y privadas
- **RDS MySQL** en subnets privadas
- **DMS Instance** para replicación
- **Bastion Host** para acceso seguro
- **Security Groups** con reglas mínimas necesarias

## Migración de Datos

1. **Configurar Endpoints DMS** (manual en consola AWS):
   - Source: MySQL local (via bastion)
   - Target: RDS MySQL

2. **Crear Tarea de Migración**:
   - Full load + CDC para sincronización continua
   - Mapeo de tablas según necesidades

3. **Monitorear Progreso**:
   - CloudWatch logs
   - DMS console metrics

## Seguridad

- RDS en subnets privadas
- Cifrado en reposo habilitado
- Backups automáticos (7 días)
- Security groups restrictivos
- Acceso via bastion host únicamente

## Limpieza

```bash
cd infra-aws
terraform destroy
```

```bash
docker-compose down -v
```

## Costos Estimados

- RDS db.t3.micro: ~$12/mes
- DMS dms.t3.small: ~$30/mes
- EC2 bastion t3.micro: ~$8/mes
- Transferencia de datos: Variable


## Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

## Autor

Erick Hoyos
