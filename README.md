# AWS Homelab Infrastructure

A self-hosted cloud infrastructure built with Terraform on AWS.

## Live Services
- ☁️ Nextcloud — https://cloud.unocloud.us
- 🔐 Vaultwarden — https://vault.unocloud.us
- 📊 Uptime Kuma — https://status.unocloud.us

## Infrastructure
- AWS VPC with public and private subnets
- EC2 Ubuntu server (t3.micro)
- Internet Gateway + Route Tables
- Elastic IP — 98.90.123.85
- Docker + Docker Compose
- Nginx reverse proxy
- SSL certificates via Let's Encrypt
- Cloudflare DNS + DDoS protection

## Self Hosted Tools
- **Nextcloud** — Personal cloud storage (Google Drive alternative)
- **Vaultwarden** — Personal password manager (Bitwarden alternative)
- **Uptime Kuma** — Server monitoring dashboard

## Tools Used
- Terraform
- AWS CLI
- Docker + Docker Compose
- Nginx
- Certbot (Let's Encrypt)
- Cloudflare
- Linux (Ubuntu 22.04)

## Author
uno-1096
