# 1. Obtener la AMI más reciente de Ubuntu 24.04 LTS de forma dinámica
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # ID oficial de Canonical (creadores de Ubuntu)
}

# 2. Crear el Security Group (Firewall)
resource "aws_security_group" "sg_laboratorio" {
  name        = "sg_dashboard_infra"
  description = "Permitir SSH y acceso al puerto 8080"

  # Acceso SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acceso a nuestra App Docker
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida libre a internet (necesaria para que el servidor descargue Docker)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Crear la Instancia EC2 (Capa Gratuita)
resource "aws_instance" "servidor_docker" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro" # O t2.micro según tu región

  # Usamos la misma llave que creamos manualmente en el paso anterior
  key_name               = "llave-laboratorio"
  vpc_security_group_ids = [aws_security_group.sg_laboratorio.id]

  # Script de Automatización (User Data) para instalar Docker al arrancar
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              # Agregar al usuario ubuntu al grupo docker para no usar 'sudo' siempre
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "servidor-automatizado-docker"
  }
}

# 4. Output para ver la IP publica en la terminal al terminar
output "instancia_ip_publica" {
  value       = aws_instance.servidor_docker.public_ip
  description = "IP pública del nuevo servidor"
}

# 5. Crear el repositorio privado en AWS ECR para almacenar nuestras imágenes Docker
resource "aws_ecr_repository" "repo_app" {
  name                 = "dashboard-infra-repo"
  image_tag_mutability = "MUTABLE"

  # Buenas prácticas: escanea la imagen en busca de vulnerabilidades al subirla
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Output para conocer la URL exacta de nuestro repositorio ECR
output "ecr_repository_url" {
  value       = aws_ecr_repository.repo_app.repository_url
  description = "URL del repositorio de AWS ECR"
}