# Сборка и загрузка образа
docker build -t custom-postgres .


# Pushing into YC (registry)
```
docker tag custom-postgres \
cr.yandex/crp0r20ste42tqg4q7ep/currency_converter-db:latest

docker push \
cr.yandex/crp0r20ste42tqg4q7ep/currency_converter-db:latest
```






# Use:
```
kubectl apply -f currency-bot.yaml

kubectl get pods -n ivanov-ns

kubectl logs -l app=ivanov-bot -n ivanov-ns --tail=100

kubectl exec -it <pod> -n ivanov-ns -- \
  sh -c "apt-get update && apt-get install -y postgresql-client && \
  psql -h db -U postgres -d currency_converter -c '\dt'"

kubectl delete -f database.yaml -f currency-bot.yaml
```
