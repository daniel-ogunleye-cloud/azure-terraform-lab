# Azure Terraform VMSS Web Service Project

This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy a scalable and highly available web application architecture on Microsoft Azure.

## Architecture Overview

The infrastructure includes:

- Azure Virtual Network (VNet)
- Subnets with Network Security Groups (NSG)
- Virtual Machine Scale Set (VMSS)
- Azure Load Balancer
- Health Probes
- Cloud-init for automatic NGINX web server installation
- Modular Terraform structure
- Environment separation (Dev)

## Key Features

- Automated infrastructure provisioning using Terraform
- Load-balanced web service on port 8080
- Auto-scaling capable VMSS backend
- Secure network access with NSG rules
- Health probe monitoring
- Reusable Terraform modules
- Git version controlled infrastructure

## Technologies Used

- Terraform
- Microsoft Azure
- Azure VM Scale Sets
- Azure Load Balancer
- Cloud-init
- Git & GitHub
- Linux (NGINX)

## Project Structure

project-2.1-webservice/
├── envs/
│ └── dev/
├── modules/
│ ├── network/
│ ├── compute_vmss/
│ └── loadbalancer/
├── providers.tf
├── variables.tf
└── outputs.tf


## Deployment Workflow

1. Terraform initialization
2. Infrastructure planning
3. Resource provisioning
4. Health validation
5. Load balancer testing using curl

## What This Project Demonstrates

- Real-world DevOps infrastructure design
- Infrastructure automation best practices
- Cloud networking fundamentals
- Scalable backend architecture
- Production-style modular Terraform structure

## Author

Daniel Ogunleye  
Cloud & DevOps Engineer (Azure)  
GitHub: https://github.com/daniel-ogunleye-cloud
