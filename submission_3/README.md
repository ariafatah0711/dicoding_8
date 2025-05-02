# Submission 3 - Order & Shipping Microservices dengan RabbitMQ, Istio, dan Kubernetes

## Deskripsi Proyek

Submission ini merupakan implementasi microservices dengan komunikasi menggunakan RabbitMQ, service mesh dengan Istio, dan dideploy menggunakan Kubernetes (Minikube).

Aplikasi terdiri dari:

* `order-service`: menerima order dari user
* `shipping-service`: menerima pesan RabbitMQ dari `order-service`
* `RabbitMQ`: sebagai message broker

## Struktur Proyek

```
submission_3/
├── kubernetes/                 # Manifest deployment dan service
│   ├── order-deployment.yaml
│   ├── shipping-deployment.yaml
│   └── rabbitmq-deployment.yaml
│   └── ecommerce-gateway.yaml
```

## Instalasi dan Deploy

### 1. Membuat Namespace

```bash
kubectl create namespace submission3
```

### 2. Enable Istio Injection

```bash
kubectl label namespace submission3 istio-injection=enabled
```

<!-- ### 3. Deploy RabbitMQ via Helm

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install rabbitmq bitnami/rabbitmq \
  --namespace submission3 \
  --create-namespace \
  --set auth.username=admin \
  --set auth.password=admin123 \
  --set fullnameOverride=rabbitmq \
  --set service.type=NodePort \
  --set service.nodePorts.amqp=30006 \
  --set service.nodePorts.manager=30007 \
  --set persistence.enabled=false
``` -->

### 3. Deploy RabbitMQ via Helm
```bash
kubectl apply -f kubernetes/rabbitmq-deployment.yaml
```

### 4. Deploy Order dan Shipping 

```bash
kubectl apply -f kubernetes/ecommerce-gateway.yaml
kubectl apply -f kubernetes/order-service-deployment.yaml
kubectl apply -f kubernetes/shipping-service-deployment.yaml

kubectl apply -f kubernetes/
```

### 5. Port Forward Dashboard RabbitMQ

```bash
kubectl port-forward --namespace submission3 svc/rabbitmq 15672:15672
```

### 6. Verifikasi Istio

```bash
istioctl analyze -n submission3
```

### 7. Setup Ingress Gateway (Jika Perlu)

```bash
minikube tunnel

export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo "$GATEWAY_URL"
echo "http://$GATEWAY_URL/order"
```

## Pengujian Aplikasi

### Kirim Order

```bash
curl -X POST http://localhost/order -H "Content-Type: application/json" \
-d '{
  "order": {
    "book_name": "Harry Potter",
    "author": "J.K Rowling",
    "buyer": "Fikri Helmi Setiawan",
    "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
  }
}'
```

### Verifikasi Logs

```bash
kubectl logs -n submission3 service/order-service
kubectl logs -n submission3 service/shipping-service
```

### Lihat Semua Resource

```bash
kubectl get all -n submission3
```

## Debugging & Restart

```bash
kubectl logs -f service/rabbitmq -n submission3
kubectl rollout restart deployment/shipping-service -n submission3

nc -zv rabbitmq 5672
```

## Cleanup

```bash
kubectl delete -f kubernetes/
helm uninstall rabbitmq --namespace submission3
kubectl delete namespace submission3
```