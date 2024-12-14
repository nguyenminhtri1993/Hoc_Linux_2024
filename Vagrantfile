# Nội dung file Vagrantfile
Vagrant.configure("2") do |config|
  # Box AlmaLinux 9
  config.vm.box = "almalinux/9"
  
  # Cấu hình Network
  config.vm.network "private_network", ip: "192.168.99.99"
  
  # Port Forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8443
  
  # Cấu hình Provider (VirtualBox)
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"  # RAM 2GB
    vb.cpus = 2         # 2 CPU cores
    vb.name = "almalinux9-dev"  # Tên máy ảo
  end
  
  # Cấu hình Provision
  config.vm.provision "shell", inline: <<-SHELL
    # Cập nhật hệ thống
    dnf update -y
    
    # Cài đặt các gói cơ bản
    dnf install -y epel-release
    dnf install -y vim wget curl net-tools
    
    # Cấu hình timezone
    timedatectl set-timezone Asia/Ho_Chi_Minh
    
    # Tắt SELinux (tùy chọn)
    # setenforce 0
    # sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
  SHELL
end