# EKS Production Platform

Production-grade AWS EKS platform demonstrating Infrastructure as Code, Kubernetes, CI/CD, GitOps, DevSecOps, observability, autoscaling, and reliability engineering.

---

## 🚀 Overview

This project implements a production-oriented cloud-native platform on AWS using:

- AWS EKS
- Terraform
- Kubernetes
- Helm
- Argo CD
- GitHub Actions
- Amazon ECR
- Python FastAPI
- Trivy
- Prometheus
- Grafana
- Metrics Server
- Horizontal Pod Autoscaler

The platform demonstrates an end-to-end software delivery workflow:

**Developer → GitHub → CI/CD → Security Scan → ECR → Helm → Argo CD → EKS → Monitoring → Autoscaling**

---

## 🏗️ Architecture

```mermaid
flowchart LR
    Developer["Developer"]

    GitHub["GitHub Repository"]
    Actions["GitHub Actions"]
    Trivy["Trivy Security Scan"]
    ECR["Amazon ECR"]

    Terraform["Terraform"]
    EKS["AWS EKS"]

    Helm["Helm Chart"]
    Argo["Argo CD"]

    App["FastAPI Application"]
    HPA["Horizontal Pod Autoscaler"]

    Prometheus["Prometheus"]
    Grafana["Grafana"]
    Metrics["Metrics Server"]

    Developer --> GitHub
    GitHub --> Actions
    Actions --> Trivy
    Trivy --> ECR
    Actions --> Helm

    Terraform --> EKS
    GitHub --> Argo
    Helm --> Argo
    Argo --> EKS

    ECR --> App
    EKS --> App

    Metrics --> HPA
    HPA --> App

    App --> Prometheus
    EKS --> Prometheus
    Prometheus --> Grafana