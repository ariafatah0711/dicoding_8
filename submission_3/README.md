# docker-compose
```bash
docker-compose up -d

curl -X POST http://localhost:3000/order   -H "Content-Type: application/json"   -d '{
    "order": {
      "book_name": "Harry Potter",
      "author": "J.K Rowling",
      "buyer": "Fikri Helmi Setiawan",
      "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
    }
  }'

docker-compose logs | grep service
docker-compose down
```

# kubernetes
```bash
kubectl create namespace submission3

# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update
# helm install rabbitmq bitnami/rabbitmq \
#   --namespace submission3 \
#   --create-namespace \
#   --set auth.username=guest \
#   --set auth.password=guest \
#   --set fullnameOverride=rabbitmq \
#   --set service.type=NodePort \
#   --set service.nodePorts.amqp=30006 \
#   --set service.nodePorts.manager=30007 \
#   --set persistence.enabled=false

kubectl apply -f kubernetes

kubectl port-forward --namespace submission3 svc/rabbitmq 15672:15672

# test
curl -X POST http://192.168.49.2:30010/order   -H "Content-Type: application/json"   -d '{
    "order": {
      "book_name": "Harry Potter",
      "author": "J.K Rowling",
      "buyer": "Fikri Helmi Setiawan",
      "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
    }
  }'

# Hapus aplikasi
kubectl delete -f kubernetes/
helm uninstall rabbitmq  --namespace submission3
kubectl delete namespace submission3
```

# draft
```bash
nc -zv rabbitmq 5672
```