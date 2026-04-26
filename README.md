# Project Bedrock: InnovateMart EKS Deployment

## Overview
This repository contains the implementation of InnovateMart's "Project Bedrock," a mission to deploy a microservices-based retail store application on Amazon Elastic Kubernetes Service (EKS). The project includes Infrastructure as Code (IaC) using Terraform, a CI/CD pipeline with GitHub Actions, and Kubernetes manifests to deploy the `retail-store-sample-app`. The setup ensures scalability, security, and developer access as per the assessment requirements.

## Repository Structure
- `/terraform/`: Terraform modules for provisioning AWS resources (VPC, EKS cluster, IAM roles).
- `/k8s/`: Kubernetes manifests for deploying the retail-store-sample-app and its in-cluster dependencies.
- `/.github/workflows/`: GitHub Actions workflows for CI/CD automation.
- `/docs/`: Deployment & Architecture Guide (see PDF for details).

## Prerequisites
- AWS CLI configured with admin access.
- Terraform v1.5.0 or higher.
- kubectl configured with access to the EKS cluster.
- GitHub repository with Actions enabled.

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/aws-containers/retail-store-sample-app
   cd retail-store-sample-app
   ```

2. **Provision Infrastructure**:
   - Navigate to `/terraform/`.
   - Run `terraform init` to initialize.
   - Run `terraform plan` to review resources.
   - Run `terraform apply` to provision the VPC, EKS cluster, and IAM roles.

3. **Configure kubectl**:
   - Update kubeconfig: `aws eks update-kubeconfig --name innovatemart-eks --region us-east-1`.

4. **Deploy Application**:
   - Navigate to `/k8s/`.
   - Apply manifests: `kubectl apply -f .`.

5. **Access the Application**:
   - The `ui` service is exposed via a ClusterIP. Use `kubectl port-forward` to access locally: `kubectl port-forward svc/ui 8080:80`.
   - Open `http://localhost:8080` in your browser.

6. **Developer Access**:
   - A read-only IAM user (`dev-user`) is created with permissions to view EKS resources.
   - Credentials are stored securely in AWS Secrets Manager (ARN provided in the guide).
   - Configure `kubectl` for the developer user.

## CI/CD Pipeline
- **Tool**: GitHub Actions.
- **Workflow**: 
  - Pushes to feature branches trigger `terraform plan`.
  - Merges to `main` trigger `terraform apply`.
- **Location**: See `.github/workflows/terraform.yml`.

## Infrastructure Decisions

**Why EKS over ECS?**
EKS gives full Kubernetes compatibility, manifests, services, and 
ingress configs are portable and not locked to AWS specific tool. 
For a microservices architecture with multiple independent services, 
Kubernetes provides better service discovery and scaling control.

**Why Terraform over CloudFormation?**
Terraform is cloud agnostic and has a cleaner module system. It also 
provides better state management and plan/apply workflow which maps 
naturally to CI/CD, you can diff infrastructure changes before 
applying them, exactly like a code review.

**Why managed databases (RDS) instead of in-cluster?**
Running databases inside Kubernetes works for dev but is a liability 
in production. RDS handles automated backups, failover, and patching. 
DynamoDB for the carts service gives auto-scaling with zero operational 
overhead, a better fit for a service with unpredictable traffic spikes.

**IAM least-privilege + Secrets Manager**
Developer access is scoped to read-only EKS permissions only. 
No credentials are hardcoded, all secrets are stored in AWS Secrets 
Manager and injected at runtime.

## Documentation
- The `doc/` folder contains the Deployment & Architecture Guide (`architecture-guide.pdf`), detailing the setup, architecture diagram, and developer access instructions.

## Security
- IAM roles follow least-privilege — each service has only the 
  permissions it needs
- Read-only `dev-user` IAM account for developer cluster access, 
  credentials stored in Secrets Manager
- HTTPS enforced via ACM certificate + Route 53
- No secrets hardcoded anywhere in the repository

## Running the Application
- The `retail-store-sample-app` runs with in-cluster MySQL, PostgreSQL, DynamoDB Local, Redis, and RabbitMQ.
- Access the UI at `http://a57a094fea6d64e5e88d1255009bd48a-402411837.us-east-1.elb.amazonaws.com/` after port-forwarding.
- Developers can use the provided IAM user credentials to view logs and pod status.

## Notes
- Ensure AWS credentials are securely managed and not hardcoded.
- The repository follows GitFlow, with `main` for production and `feature/*` for development.
- For bonus objectives, Route 53 domain setup uses a placeholder

## Contact
Built by [Chisom Okeke](https://github.com/kergs)  
📫 cchisomfrancis@gmail.com · X [@_kergs](https://twitter.com/_kergs)
