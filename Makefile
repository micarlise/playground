
.PHONY: cluster kind metallb
cluster: kind metallb

kind: conf/kind-config.yaml
	kind create cluster --config conf/kind-config.yaml
	sudo route -v add -net 172.18.0.1 -netmask 255.255.0.0 10.0.75.2

metallb: kind
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
	kubectl create -f conf/metallb-config.yaml

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