
.PHONY: cluster
cluster: conf/kind-config.yaml
	kind create cluster --config conf/kind-config.yaml

# metrics layer
.PHONY: metrics prometheus grafana
metrics: prometheus grafana

prometheus: helm-stable
	helm install prometheus stable/prometheus

grafana: helm-grafana
	helm install \
		-f conf/grafana-values.yml \
		--set sidecar.dashboards.enabled=true \
		grafana grafana/grafana

# helm repos
.PHONY: helms-stable helm-grafana
helm-stable: 
	helm repo add stable https://charts.helm.sh/stable

helm-grafana:
	helm repo add grafana https://grafana.github.io/helm-charts

# databases
.PHONY: mongodb
mongodb: 
	helm install \
		mongodb databases/mongodb

.PHONY: clean
clean:
	kind delete cluster