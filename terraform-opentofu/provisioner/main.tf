# 1. Define the Provider
terraform {
  required_providers {
    multipass = {
      source  = "todoroff/multipass"
    }
  }
}


# 2. Configure the Multipass Instance
resource "multipass_instance" "web_server" {
  name   = "tofu-web-vm"
  cpus   = 1
  image  = "24.04" 
  memory = "1G"
  disk   = "5G"


}

# 3. Output the IP address so you can find it easily
output "vm_ip" {
  value = multipass_instance.web_server.ipv4
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 22.04 LTS (Region specific)
  instance_type = "t2.micro"
  key_name      = "my-ssh-key" # Ensure this key exists in AWS

  # Security group to allow SSH and HTTP
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  # 1. Connection block tells provisioners how to communicate with the resource
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa") # Path to your local private key
    host        = self.public_ip
  }

  # 2. The Provisioner to install Nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

  tags = {
    Name = "Terraform-Nginx-Example"
  }
}