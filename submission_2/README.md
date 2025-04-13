# Submission 2 - Aplikasi Web dengan Kubernetes

## Deskripsi Proyek
Proyek ini adalah implementasi aplikasi web menggunakan Kubernetes yang terdiri dari:
- Frontend service
- Backend service
- MongoDB database
- Monitoring stack (Prometheus & Grafana)

## Prasyarat
- Kubernetes cluster
- Helm package manager
- kubectl CLI

## Struktur Proyek
```
submission_2/
├── kubernetes/
│   ├── mongodb/
│   ├── backend/
│   └── frontend/
└── monitoring/
    └── grafana-values.yaml
```

## Instalasi

### 1. Setup Namespace
```bash
kubectl create namespace submission2
```

### 2. Deploy Aplikasi
```bash
# Deploy MongoDB
kubectl apply -f kubernetes/mongodb/

# Deploy Backend
kubectl apply -f kubernetes/backend/

# Deploy Frontend
kubectl apply -f kubernetes/frontend/
```

### 3. Verifikasi Deployment
```bash
# Cek status resources
kubectl get pv,pvc,secret,configmap -o wide
kubectl get all -o wide -n submission2
```

## Monitoring Stack

### Instalasi Manual
```bash
# Buat namespace monitoring
kubectl create namespace monitoring

# Tambahkan Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Install Prometheus
helm install prometheus prometheus-community/prometheus -n monitoring

# Install Grafana
helm install grafana grafana/grafana --namespace monitoring \
  --set adminPassword='admin' \
  --set service.type=NodePort

# Verifikasi instalasi
kubectl get all -n monitoring
```

### Instalasi Otomatis
```bash
# Buat namespace monitoring
kubectl create namespace monitoring

# Tambahkan Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Install Prometheus dan Grafana
helm install prometheus prometheus-community/prometheus -n monitoring
helm install grafana grafana/grafana -f monitoring/grafana-values.yaml -n monitoring

# Verifikasi instalasi
kubectl get all -n monitoring
```

### Konfigurasi Grafana
1. Akses Grafana melalui port-forward:
```bash
kubectl port-forward svc/grafana -n monitoring 30003:80
```

2. Login dengan kredensial:
   - Username: admin
   - Password: admin

3. Tambahkan data source Prometheus:
   - URL: http://prometheus-server.monitoring.svc.cluster.local

4. Import dashboard:
   - Template ID: 6417 (Kubernetes Cluster Prometheus)
   - URL: https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/

## Akses Aplikasi
- Frontend: http://localhost:30000
- Backend: http://localhost:30001
- Monitoring: http://localhost:30002

## Cleanup
Untuk menghapus semua resources:
```bash
# Hapus aplikasi
kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/frontend/

# Hapus namespace
kubectl delete namespace submission2

# Hapus monitoring stack
kubectl delete namespace monitoring
```

## Referensi
- [Grafana Helm Charts](https://grafana.github.io/helm-charts/)
- [Kubernetes Cluster Prometheus Dashboard](https://grafana.com/grafana/dashboards/6417-kubernetes-cluster-prometheus/)