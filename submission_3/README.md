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
kubectl label namespace submission3 istio-injection=enabled

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

kubectl apply -f kubernetes/rabbitmq-deployment.yaml
kubectl port-forward --namespace submission3 svc/rabbitmq 15672:15672

kubectl apply -f kubernetes

istioctl analyze

# istio
minikube tunnel
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
echo "$INGRESS_HOST" "$INGRESS_PORT" "$SECURE_INGRESS_PORT"
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "$GATEWAY_URL"
echo "http://$GATEWAY_URL/order"

# test post
# curl -X POST http://$(minikube ip)/order -H "Content-Type: application/json" \
curl -X POST http://localhost/order -H "Content-Type: application/json" \
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
kubectl logs -f service/rabbitmq -n submission3
kubectl rollout restart deployment/shipping-service -n submission3

nc -zv rabbitmq 5672
curl -u guest:guest http://rabbitmq:15672/api/overview
curl -u admin:admin123 http://rabbitmq:15672/api/overview
```