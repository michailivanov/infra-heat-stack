`kubectl apply -f database.yaml` - database


# Pushing into YC (registry)
```
docker tag custom-postgres \
cr.yandex/crp0r20ste42tqg4q7ep/taskbot-db:latest

docker push \
cr.yandex/crp0r20ste42tqg4q7ep/taskbot-db:latest
```

# Useful:
```
kubectl apply -f taskbot.yaml

kubectl get pods -n ivanov-ns

kubectl logs -l app=ivanov-bot -n ivanov-ns --tail=100

kubectl exec -it <pod> -n ivanov-ns -- \
  sh -c "apt-get update && apt-get install -y postgresql-client && \
  psql -h db -U postgres -d tasks -c '\dt'"

kubectl delete -f database.yaml -f taskbot.yaml
```
