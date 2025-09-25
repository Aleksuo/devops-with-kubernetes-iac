output "cluster_id" {
  value = format("doctl kubernetes cluster kubeconfig save %s", digitalocean_kubernetes_cluster.kubernetes_exercises.id)
}