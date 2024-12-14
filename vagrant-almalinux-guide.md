# Hướng dẫn cài đặt AlmaLinux 9 trên Vagrant

## Phần 1: Chuẩn bị môi trường

### 1.1. Yêu cầu hệ thống
- CPU hỗ trợ ảo hóa (VT-x/AMD-V)
- RAM tối thiểu 4GB
- Ổ cứng trống ít nhất 20GB
- Internet ổn định

### 1.2. Cài đặt phần mềm cần thiết

1. **Cài đặt VirtualBox**
```bash
# Windows: Tải từ virtualbox.org
# Linux (Ubuntu/Debian):
sudo apt update
sudo apt install virtualbox

# Linux (RHEL/CentOS/AlmaLinux):
sudo dnf install virtualbox
```

2. **Cài đặt Vagrant**
```bash
# Windows: Tải từ vagrantup.com
# Linux (Ubuntu/Debian):
sudo apt install vagrant

# Linux (RHEL/CentOS/AlmaLinux):
sudo dnf install vagrant
```

3. **Kiểm tra cài đặt**
```bash
vagrant --version
VBoxManage --version
```

## Phần 2: Khởi tạo dự án Vagrant

### 2.1. Tạo thư mục dự án
```bash
# Tạo và di chuyển vào thư mục dự án
mkdir vagrant-almalinux9
cd vagrant-almalinux9

# Khởi tạo Vagrantfile
vagrant init almalinux/9
```

### 2.2. Cấu hình Vagrantfile
```ruby
# Nội dung file Vagrantfile
Vagrant.configure("2") do |config|
  # Box AlmaLinux 9
  config.vm.box = "almalinux/9"
  
  # Cấu hình Network
  config.vm.network "private_network", ip: "192.168.56.10"
  
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
```

## Phần 3: Khởi động và quản lý máy ảo

### 3.1. Khởi động máy ảo
```bash
# Khởi động máy ảo
vagrant up

# Kiểm tra status
vagrant status
```

### 3.2. Kết nối SSH vào máy ảo
```bash
# Kết nối SSH
vagrant ssh

# Kiểm tra hệ thống
cat /etc/almalinux-release
uname -a
```

### 3.3. Các lệnh Vagrant cơ bản
```bash
# Tạm dừng máy ảo
vagrant suspend

# Khởi động lại từ trạng thái suspend
vagrant resume

# Tắt máy ảo
vagrant halt

# Khởi động lại máy ảo
vagrant reload

# Xóa máy ảo
vagrant destroy
```

## Phần 4: Cấu hình nâng cao

### 4.1. Đồng bộ thư mục
```ruby
# Thêm vào Vagrantfile
config.vm.synced_folder "src/", "/var/www/html"
```

### 4.2. Multi-machine setup
```ruby
Vagrant.configure("2") do |config|
  # Web Server
  config.vm.define "web" do |web|
    web.vm.box = "almalinux/9"
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.56.11"
  end
  
  # Database Server
  config.vm.define "db" do |db|
    db.vm.box = "almalinux/9"
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.12"
  end
end
```

### 4.3. Provision với Ansible
```ruby
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "playbook.yml"
end
```

## Phần 5: Bảo mật và tối ưu hóa

### 5.1. Cấu hình Firewall
```bash
# Trong provision script
dnf install -y firewalld
systemctl enable firewalld
systemctl start firewalld

# Mở các port cần thiết
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

### 5.2. SSH Configuration
```ruby
config.ssh.username = "vagrant"
config.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
```

## Phần 6: Các tip và trick

### 6.1. Snapshot
```bash
# Tạo snapshot
vagrant snapshot save initial_setup

# Restore snapshot
vagrant snapshot restore initial_setup
```

### 6.2. Box Management
```bash
# Liệt kê các box đã cài
vagrant box list

# Xóa box
vagrant box remove almalinux/9

# Update box
vagrant box update
```

### 6.3. Debug và Troubleshooting
```bash
# Chạy với debug mode
vagrant up --debug

# Kiểm tra log
vagrant ssh -- "sudo journalctl -xe"
```

## Phần 7: Các lỗi thường gặp và cách khắc phục

### 7.1. Network Issues
- Kiểm tra VirtualBox Network Adapter
- Verify IP conflict
- Kiểm tra firewall host

### 7.2. Performance Issues
- Giảm RAM/CPU nếu host không đủ tài nguyên
- Disable các service không cần thiết
- Sử dụng lightweight provisioner

## Ghi chú quan trọng

1. Backup Vagrantfile và data quan trọng
2. Sử dụng version control cho configuration
3. Test configuration trên môi trường dev trước
4. Cập nhật box và plugin thường xuyên

## Tài liệu tham khảo
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [AlmaLinux Documentation](https://wiki.almalinux.org/)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
