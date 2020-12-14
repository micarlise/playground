
cluster: kind-config.yaml
	kind create cluster --config kind-config.yaml

prometheus: stable
	helm install prometheus stable/prometheus

stable: 
	helm repo add stable https://charts.helm.sh/stable



clean:
	kind delete cluster

.PHONY: cluster prometheus stable clean
