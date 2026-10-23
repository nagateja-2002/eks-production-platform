variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for AWS resources"
  type        = string
  default     = "eks-production-platform"
}

variable "availability_zones" {
  description = "Two Availability Zones in aws_region for the public and private subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Provide exactly two distinct Availability Zones."
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "Trusted CIDR ranges allowed to reach the public EKS Kubernetes API endpoint. Use your current public IP with /32 for an individual IPv4 address."
  type        = list(string)

  validation {
    condition = (
      length(var.cluster_endpoint_public_access_cidrs) > 0 &&
      !contains(var.cluster_endpoint_public_access_cidrs, "0.0.0.0/0") &&
      !contains(var.cluster_endpoint_public_access_cidrs, "::/0")
    )
    error_message = "Supply at least one trusted CIDR and do not allow the public EKS endpoint from the entire IPv4 or IPv6 internet."
  }
}
