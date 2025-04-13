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