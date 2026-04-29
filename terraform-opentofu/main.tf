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

  # Optional: Pass a cloud-init config to install Nginx automatically
  cloud_init = <<-EOT
    #cloud-config
    package_update: true
    packages:
      - nginx
    runcmd:
      - systemctl enable nginx
      - systemctl start nginx
  EOT
}

# 3. Output the IP address so you can find it easily
output "vm_ip" {
  value = multipass_instance.web_server.ipv4
}
