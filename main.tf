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


resource "null_resource" "install_argocd" {
  
  provisioner "local-exec" {
    command = <<EOF
      
      kubectl create namespace argocd
      kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
      kubectl apply -f application.yaml
      kubectl apply -f application-crd.yaml
      kubectl apply -f cert-manager-crds.yaml
      kubectl apply -f deploy-ingress-nginx-crd.yaml
      kubectl create -f letsencrypt-staging.yaml
  EOF
  }
  
  
  depends_on = [kind_cluster.default]
  
}









