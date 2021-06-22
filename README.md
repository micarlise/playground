
## Playground

A local [KinD](https://kind.sigs.k8s.io/) cluster for local testing helm charts
and CI/CD.  This is inspired by how SIG-Testing test kubernetes. 

### Setup

Install any missing dependencies on your system

* [Docker](https://docs.docker.com/get-docker/)
* [kind installation guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
* [helm installation guide](https://helm.sh/docs/intro/install)


#### Build a local cluster 

From the root directory of this repo

```
make cluster
```

You'll get a 5 node cluster that runs inside Docker.  Loadbalancers will work
inside this cluster.  Modifications can be made by editing
`conf/kind-config.yaml`.  Consult [KinD docs](https://kind.sigs.k8s.io) for ideas.

#### Adding metrics and dashboards 

You can install prometheus and grafana using the `metrics` target.

```
make metrics
```

**Connect to grafana dashboard**

Port-forward the grafana svc to your localhost.

```
kubectl port-forward svc/grafana 3000:80
```

Visit localhost:3000/ in your browser.  Username/password is `admin`:`password`.

![grafana home page](docs/grafana-home.png?raw=true)

**Auto import metric dashboards for your charts**

grafana will import any configmap with the label `grafana_dashboard=1` as a
dashboard.  To utilize this, you can export the dashboard json and put into 
the root directory of your helm chart.  Then create the configmap as a File 
import.

```yaml
{{- if .Values.dashboard.enabled -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: sample-grafana-dashboard
  labels:
     grafana_dashboard: "1"
data:
  k8s-dashboard.json: |-
{{ .Files.Get "dashboard.json" | indent 4 }} 
{{- end }}
```

## Add databases 

**mongodb**

```
make mongodb
```
