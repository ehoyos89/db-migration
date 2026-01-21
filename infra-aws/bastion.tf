data "aws_ami" "nixos_latest" {
  most_recent = true
  owners      = ["427812963091"] # Owner ID oficial de NixOS
  filter {
    name   = "name"
    values = ["nixos/24.11*"] # Busca la AMI más reciente de x86_64
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "nixos_server" {
  ami           = data.aws_ami.nixos_latest.id
  instance_type = var.bastion_instance_type
  key_name      = var.key_name 
  subnet_id     = aws_subnet.public-1.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "NixOSTestServer"
  }

  connection {
    type        = "ssh"
    user        = "root" 
    private_key = file("~/Documentos/proyectos/db-migration/infra-aws/pop.pem") # Ruta a la llave privada que corresponde al key_name
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "~/Documentos/proyectos/db-migration/infra-aws/flake-wireguard" # Ruta a tu carpeta local
    destination = "/tmp/flake-wireguard"   # Destino temporal en la instancia EC2
  }

  provisioner "file" {
    source      = "~/Documentos/proyectos/db-migration/infra-aws/server-keys"
    destination = "/tmp/server-keys"   
    
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Conectado a la instancia... moviendo archivos de NixOS.'",
      "sudo mv /tmp/flake-wireguard/* /etc/nixos/",
      "sudo mkdir -p /etc/wireguard",
      "sudo mv /tmp/server-keys/* /etc/wireguard/",
      "sudo chmod 600 /etc/wireguard/private.key",
      "sudo rm -rf /tmp/flake-wireguard",
      "echo 'Archivos movidos. Reconstruyendo el sistema con la nueva configuración flake...'",
      "sudo nixos-rebuild switch --flake /etc/nixos#bastion",
      "echo 'Sistema reconstruido y WireGuard configurado.'" 
    ]
  }
}

