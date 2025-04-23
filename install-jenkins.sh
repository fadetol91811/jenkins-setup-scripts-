#!/bin/bash

# Hardened, Idempotent Jenkins Installer - Landmark Tech
# Compatible: RHEL 7/8/9, Amazon Linux 2 (T2.medium+, 4GB+ RAM)
# Author: Prof Legah

set -euo pipefail

JENKINS_REPO="/etc/yum.repos.d/jenkins.repo"
JENKINS_KEY="https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key"
JENKINS_REPO_URL="https://pkg.jenkins.io/redhat-stable/jenkins.repo"
LOG_FILE="/var/log/jenkins_install.log"
JAVA_PACKAGE="java-17-openjdk"
PORT=8080

echo "🚀 Starting Jenkins installation..." | tee -a $LOG_FILE

# ---- [0] Root Check ----
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run as root." | tee -a $LOG_FILE
  exit 1
fi

# ---- [1] Set Hostname and Timezone ----
echo "🕓 Configuring timezone and hostname..." | tee -a $LOG_FILE
timedatectl set-timezone America/New_York
hostnamectl set-hostname jenkins

# ---- [2] Install Dependencies ----
echo "📦 Installing base packages..." | tee -a $LOG_FILE
yum install -y wget git tree vim nano unzip curl net-tools >> $LOG_FILE 2>&1

# ---- [3] Install Java (required for Jenkins) ----
echo "☕ Installing Java (17)..." | tee -a $LOG_FILE
yum install -y ${JAVA_PACKAGE} >> $LOG_FILE 2>&1

# ---- [4] Add Jenkins Repository ----
if [ ! -f "$JENKINS_REPO" ]; then
  echo "📡 Adding Jenkins repository..." | tee -a $LOG_FILE
  wget -O "$JENKINS_REPO" "$JENKINS_REPO_URL" >> $LOG_FILE 2>&1
  rpm --import "$JENKINS_KEY"
else
  echo "ℹ️ Jenkins repo already configured" | tee -a $LOG_FILE
fi

# ---- [5] Install Jenkins ----
echo "⚙️ Installing Jenkins..." | tee -a $LOG_FILE
yum install -y jenkins >> $LOG_FILE 2>&1

# ---- [6] Enable and Start Jenkins ----
echo "🔁 Enabling and starting Jenkins service..." | tee -a $LOG_FILE
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# ---- [7] Firewall (Optional – open port 8080) ----
# Uncomment to open port via firewall
# firewall-cmd --permanent --add-port=${PORT}/tcp
# firewall-cmd --reload

# ---- [8] Output Initial Admin Info ----
echo "✅ Jenkins installation completed." | tee -a $LOG_FILE
echo "🌐 Access Jenkins at: http://<your-ec2-public-ip>:8080"
echo "🔐 Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "🔒 File not yet created. Check after first boot."
