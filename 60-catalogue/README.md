# 🏷️ 60-Catalogue

This layer is responsible for deploying the **Catalogue** microservice for the Roboshop application. It demonstrates an advanced, highly available, and auto-scaling infrastructure pattern using AWS Auto Scaling Groups (ASG), Launch Templates, and Application Load Balancer integration.

## 📋 Overview

The `60-catalogue` module performs the following critical functions:
1. **AMI Baking (Golden Image)**: Provisions a temporary EC2 instance, bootstraps the catalogue application using `bootstrap.sh`, and captures it as a custom Amazon Machine Image (AMI). The temporary instance is then destroyed.
2. **Launch Template**: Creates an AWS Launch Template using the generated Golden Image, ensuring that all future instances spin up fully configured.
3. **Auto Scaling Group (ASG)**: Deploys an ASG in the private subnets. The ASG manages the desired capacity, scaling out or in based on configured policies (e.g., CPU utilization).
4. **Load Balancer Integration**: Creates a Target Group and a Listener Rule to attach the Catalogue ASG instances to the Backend ALB created in the `50-backend-alb` layer, routing traffic based on the `catalogue` path or header.

## 🏗️ Architecture Visualization

The flowchart below visualizes the lifecycle of the Catalogue deployment, from Golden Image creation to Auto Scaling integration.

```mermaid
graph TD
    %% Inputs
    subgraph Inputs [Variables & Data Sources]
        AMI["local.ami_id (Base OS)"]
        PRIV_SUB["local.private_subnet_ids"]
        SG["local.catalogue_sg_id"]
        ALB_LIST["local.backend_alb_listener_arn"]
    end

    %% Phase 1: Baking
    subgraph Baking [Golden Image Creation]
        TEMP_EC2["Temporary EC2 Instance"]
        BOOT["bootstrap.sh (App Setup)"]
        NEW_AMI["aws_ami_from_instance (Golden AMI)"]
    end

    %% Phase 2: Scaling
    subgraph Scaling [Auto Scaling Infrastructure]
        LT["aws_launch_template"]
        ASG["aws_autoscaling_group"]
        POLICY["aws_autoscaling_policy (Scaling Rules)"]
    end

    %% Phase 3: Networking
    subgraph Routing [Load Balancing]
        TG["aws_lb_target_group"]
        RULE["aws_lb_listener_rule"]
    end

    %% Connections
    AMI --> TEMP_EC2
    TEMP_EC2 -->|"Executes"| BOOT
    BOOT -->|"Captures"| NEW_AMI
    TEMP_EC2 -.->|"Destroyed after creation"| NEW_AMI

    NEW_AMI --> LT
    SG --> LT
    
    LT --> ASG
    PRIV_SUB --> ASG
    POLICY --> ASG

    ASG -->|"Registers Instances"| TG
    ALB_LIST --> RULE
    TG --> RULE
```

## 🔐 Security and Access
- **Private Subnet Placement**: All Catalogue instances spawned by the ASG are isolated within the private subnets.
- **Dynamic Port Mapping**: Instances only accept traffic from the Backend ALB security group, ensuring they cannot be bypassed.

## 🚀 Execution

To provision the Catalogue service:
```bash
cd 60-catalogue
terraform init
terraform apply -auto-approve
```
