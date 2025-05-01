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
kubectl apply -f kubernetes

curl -X POST http://192.168.49.2:30010/order   -H "Content-Type: application/json"   -d '{
    "order": {
      "book_name": "Harry Potter",
      "author": "J.K Rowling",
      "buyer": "Fikri Helmi Setiawan",
      "shipping_address": "Jl. Batik Kumeli no 50 Bandung"
    }
  }'

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install rabbitmq bitnami/rabbitmq --namespace submission3

# Hapus aplikasi
kubectl delete -f kubernetes/

# Hapus namespace
kubectl delete namespace submission3
```