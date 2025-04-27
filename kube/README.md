```
docker build -t custom-postgres .

docker tag custom-postgres \
cr.yandex/crp0r20ste42tqg4q7ep/currency_converter-db:latest

docker push \
cr.yandex/crp0r20ste42tqg4q7ep/currency_converter-db:latest
```

```
docker build -t currency-bot:localtunnel .

docker tag currency-bot:localtunnel \
cr.yandex/crp0r20ste42tqg4q7ep/currency-bot:latest

docker push \
cr.yandex/crp0r20ste42tqg4q7ep/currency-bot:latest

```






# Use:
```
kubectl apply -f currency-bot.yaml -n ivanov-ns

kubectl apply -f database.yaml -n ivanov-ns

kubectl apply -f database.yaml -f currency-bot.yaml

kubectl apply -f currency-bot.yaml

kubectl get pods -n ivanov-ns

kubectl logs -l app=ivanov-bot -n ivanov-ns --tail=100

kubectl exec -it <pod> -n ivanov-ns -- \
  sh -c "apt-get update && apt-get install -y postgresql-client && \
  psql -h db -U postgres -d currency_converter -c '\dt'"

kubectl delete -f database.yaml -f currency-bot.yaml
```

```
docker run -p 8081:8081 currency-bot:localtunnel

docker tag currency-bot:localtunnel michailivanov/currency-converter-bot:latest
docker push michailivanov/currency-converter-bot:latest
```
