```bash
kubectl apply -f .\mongo-service.yml -f .\mongo-configmap.yml -f .\mongo-secret.yml -f .\mongo-statefulset.yml -f .\mongo-pv-pvc.yml -n dicoding

kubectl apply -f .\karsajobs-service.yml -f .\karsajobs-deployment.yml -n dicoding

kubectl apply -f .\karsajobs-ui-deployment.yml -f .\karsajobs-ui-service.yml -n dicoding
```