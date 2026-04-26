# 🔐 70-ACM (AWS Certificate Manager)

This layer provisions and automatically validates an SSL/TLS Certificate for the Roboshop application domain. Securing the domain with HTTPS is a critical step before deploying the public-facing Frontend Application Load Balancer.

## 📋 Overview

The `70-acm` module performs the following functions:
1. **Certificate Request**: Requests a wildcard SSL certificate (e.g., `*.roboshop.com`) from AWS Certificate Manager (ACM).
2. **DNS Validation**: Automatically extracts the required Domain Validation Options (DVOs) from the requested certificate and creates the necessary validation records in AWS Route53.
3. **Certificate Validation**: Tells Terraform to wait until AWS confirms that the DNS records are active and the certificate is fully validated.
4. **Parameter Export**: Exports the validated Certificate ARN to the SSM Parameter Store so it can be consumed by the Frontend ALB in the next layer.

## 🏗️ Architecture Visualization

The flowchart below visualizes the automated validation loop between ACM and Route53.

```mermaid
graph TD
    %% Inputs
    subgraph Inputs [Variables & Data Sources]
        DOMAIN["var.domain_name"]
        ZONE["var.zone_id"]
    end

    %% Resources
    subgraph Cert_Manager [AWS ACM & Route53]
        REQ["aws_acm_certificate (Request)"]
        DNS["aws_route53_record (Validation Records)"]
        VAL["aws_acm_certificate_validation (Wait)"]
    end

    %% Outputs
    subgraph SSM [AWS SSM Parameter Store]
        SSM_CERT["/var.project/var.environment/frontend_alb_certificate_arn"]
    end

    %% Connections
    DOMAIN --> REQ
    REQ -->|"Provides DVOs"| DNS
    ZONE --> DNS
    
    DNS -->|"Proves Ownership"| VAL
    REQ -->|"Certificate ARN"| VAL
    
    VAL -->|"Validated ARN"| SSM_CERT
```

## 🔐 Security and Access
- **Lifecycle Rules**: The certificate is configured with `create_before_destroy = true`. This ensures zero-downtime certificate rotations in the future by bringing up the new certificate before deleting the old one.
- **Automated Validation**: Because validation uses DNS records in Route53, it removes the need for manual email validation, allowing for complete infrastructure automation.

## 🚀 Execution

To provision the ACM Certificate:
```bash
cd 70-acm
terraform init
terraform apply -auto-approve
```
