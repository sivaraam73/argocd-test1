# versions.tf

terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.17"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }

  required_version = ">= 1.4.5"
}
