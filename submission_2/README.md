```bash
# show
kubectl get pv,pvc,secret,configmap -o wide
kubectl get all -o wide -n submission2

# create
kubectl create namespace submission2
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/frontend/
kubectl get pv,pvc,secret,configmap -o wide
kubectl get all -o wide -n submission2

# delete
kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/frontend/
kubectl delete namespace submission2
```

- [https://grafana.github.io/helm-charts/](https://grafana.github.io/helm-charts/)
- [https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/](https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/)

# prometheus grafana manual
```bash
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm install prometheus prometheus-community/prometheus -n monitoring
helm install grafana grafana/grafana --namespace monitoring --set adminPassword='admin' --set service.type=NodePort
kubectl get all -n monitoring

# check
kubectl port-forward svc/prometheus-server -n monitoring 30003:80
kubectl port-forward svc/grafana -n monitoring 30003:80
# admin:admin crednya
# add data source with this: http://prometheus-server.monitoring.svc.cluster.local
# add dashbord wtih template this: https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/

# delete
kubectl delete namespace monitoring
```

# prometheus grafana auto
```bash
kubectl create namespace monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

helm install prometheus prometheus-community/prometheus -n monitoring
helm install grafana grafana/grafana -f monitoring/grafana-values.yaml -n monitoring
kubectl get all -n monitoring

# check the localhost:30003
```