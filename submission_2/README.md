```bash
kubectl create namespace submission2
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/frontend/
kubectl get all,pv,pvc,secret,configmap -o wide

kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/frontend/
kubectl delete namespace submission2
```