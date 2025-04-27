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

kubectl logs -l app=ivanov-bot -n ivanov-ns

kubectl delete -f database.yaml -f currency-bot.yaml
```

```
kubectl get pods -n ivanov-ns 

kubectl exec -it ivanov-bot-74c7f78fb4-pnzqv -n ivanov-ns -- sh

kubectl logs ivanov-bot-74c7f78fb4-pnzqv -n ivanov-ns
```
