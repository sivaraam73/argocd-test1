# kind_cluster.tf

provider "kind" {
}

provider "kubernetes" {
  config_path = pathexpand(var.kind_cluster_config_path)
}

provider "kubectl" {
      host = "${kind_cluster.default.endpoint}"
      cluster_ca_certificate = "${kind_cluster.default.cluster_ca_certificate}"
      client_certificate = "${kind_cluster.default.client_certificate}"
      client_key = "${kind_cluster.default.client_key}"
    }



resource "kind_cluster" "default" {
  name            = var.kind_cluster_name
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      image = "kindest/node:v1.26.3"
      #image = "kindest/node:v1.25.8"
      
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port      = 8080
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 44300
      }
    }

    node {
      role = "worker"
      image = "kindest/node:v1.26.3"
      #image = "kindest/node:v1.25.8"
    }
    
    node {
      role = "worker"
      image = "kindest/node:v1.26.3"
      #image = "kindest/node:v1.25.8"
    }
    
    node {
      role = "worker"
      image = "kindest/node:v1.26.3"
      #image = "kindest/node:v1.25.8"
    }
    
  }
}



# Helm Resource to Create Argo CD

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}


resource "helm_release" "argocd" {
  name  = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.28.0"
  create_namespace = true

  values = [
    file("argocd/application.yaml")
  ]
  
  depends_on = [kind_cluster.default]
  
}









