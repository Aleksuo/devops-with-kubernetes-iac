terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do-token
}

data "digitalocean_regions" "all" {}

output "region_slugs" {
  value = [for r in data.digitalocean_regions.all.regions : r.slug]
}

data "digitalocean_sizes" "all" {}
output "size_slugs" {
    value = [for r in data.digitalocean_sizes.all.sizes : r.slug]
}

data "digitalocean_kubernetes_versions" "current" {}

resource "digitalocean_container_registry" "exercises" {
  name = "exercises"
  subscription_tier_slug = "basic"
  lifecycle {
    prevent_destroy = false
  }
}

resource "digitalocean_kubernetes_cluster" "kubernetes_exercises" {
  name    = "kubernetes-exercises"
  region  = "fra1"
  version = data.digitalocean_kubernetes_versions.current.latest_version
  registry_integration = true

  cluster_subnet = "172.27.0.0/16"
  service_subnet = "172.28.0.0/20"

  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}