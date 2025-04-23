# Jenkins Setup Script for RHEL / CentOS / Amazon Linux

🚀 A hardened, idempotent installation script to deploy Jenkins on Red Hat-based EC2 instances (T2.medium or higher). Built for production-ready DevOps CI environments.

---

## 🛠️ Features

- Sets timezone and hostname for consistency
- Installs Java 17 (Jenkins prerequisite)
- Configures Jenkins repo and installs latest stable version
- Enables and starts Jenkins via `systemd`
- Outputs initial admin password for first login
- Designed for Red Hat, CentOS, Amazon Linux (7/8/9)

---

## 📦 Requirements

- EC2 instance (T2.medium or larger recommended)
- OS: RHEL 7/8/9, CentOS 7/8/9, or Amazon Linux 2
- Internet access to fetch packages and Jenkins repo

---

## 🧪 Installation Steps

```bash
chmod +x install-jenkins.sh
sudo ./install-jenkins.sh
