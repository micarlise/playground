
cluster: kind-config.yaml
	kind create cluster --config conf/kind-config.yaml

# metrics layer
metrics: prometheus grafana

prometheus: helm-stable
	helm install prometheus stable/prometheus

grafana: helm-grafana
	helm install \
		-f conf/grafana-values.yml \
		grafana grafana/grafana

helm-stable: 
	helm repo add stable https://charts.helm.sh/stable

helm-grafana:
	helm repo add grafana https://grafana.github.io/helm-charts

# 
clean:
	kind delete cluster

.PHONY: cluster prometheus helm-stable clean grafana helm-grafana
.PHONY: metrics
