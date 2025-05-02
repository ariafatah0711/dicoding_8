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

# istio
# kubectl label namespace submission3 istio-injection=enabled

# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update
# helm install rabbitmq bitnami/rabbitmq \
#   --namespace submission3 \
#   --create-namespace \
#   --set auth.username=admin \
#   --set auth.password=admin123 \
#   --set fullnameOverride=rabbitmq \
#   --set service.type=NodePort \
#   --set service.nodePorts.amqp=30006 \
#   --set service.nodePorts.manager=30007 \
#   --set persistence.enabled=false \

kubectl apply -f kubernetes

kubectl port-forward --namespace submission3 svc/rabbitmq 15672:15672

# test post
curl -X POST http://$(minikube ip)/order -H "Content-Type: application/json" \
-d '{
  "order": {
    "book_name": "Harry Potter",
    "author": "J.K Rowling",
    "buyer": "Fikri Helmi Setiawan",
    "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
  }
}'

# show
kubectl get all -n submission3

# verifikasi
kubectl logs -n submission3 service/order-service
kubectl logs -n submission3 service/shipping-service

# Hapus aplikasi
kubectl delete -f kubernetes/
helm uninstall rabbitmq  --namespace submission3
kubectl delete namespace submission3
```

# draft
```bash
nc -zv rabbitmq 5672
curl -u guest:guest http://rabbitmq:15672/api/overview
curl -u admin:admin123 http://rabbitmq:15672/api/overview
```