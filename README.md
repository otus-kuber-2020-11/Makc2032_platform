# Makc2032_platform
Makc2032 Platform repository

## kubernetes-operators
<details>

Вывод команды kubectl get jobs:
```shell
NAME                         COMPLETIONS   DURATION   AGE
backup-mysql-instance-job    1/1           2s         7m27s
restore-mysql-instance-job   1/1           46s        6m12s
```

Вывод при запущенном MySQL:
```shell
mysql: [Warning] Using a password on the command line interface can be insecure.
+----+-------------+
| id | name        |
+----+-------------+
|  1 | some data   |
|  2 | some data-2 |
+----+-------------+
```

</details>

## kubernetes-monitoring
<details>

Устанавливаем kube-prometheus-stack со своим values.yaml
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -f ./values.yaml
```

Применяем манифесты по nginx
```shell
kubectl apply -f ./nginx/configmap.yaml ./nginx/deployment.yaml ./nginx/service.yaml ./servicemonitor.yaml
```

Скриншот dashboard из Grafana для nginx-exporter
![Alt text](./kubernetes-monitoring/screenshot.png?raw=true "Grafana")

</details>

## kubernetes-gitops
<details>

Найдите в логах helm-operator строки, указывающие на механизм
проверки изменений в Helm chart и определения необходимости
обновить релиз. Приложите данные строки:
```shell
ts=2021-05-06T09:43:58.989470295Z caller=release.go:311 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="no changes" phase=dry-run-compare
ts=2021-05-06T09:44:17.222282168Z caller=release.go:79 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="starting sync run"
ts=2021-05-06T09:44:17.511803446Z caller=release.go:353 component=release release=frontend targetNamespace=microservices-demo resource=microservices-demo:helmrelease/frontend helmVersion=v3 info="running upgrade" action=upgrade
ts=2021-05-06T09:44:17.548638457Z caller=helm.go:69 component=helm version=v3 info="preparing upgrade for frontend" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:17.554706577Z caller=helm.go:69 component=helm version=v3 info="resetting values to the chart's original version" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:17.831229828Z caller=helm.go:69 component=helm version=v3 info="performing update for frontend" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:17.968551829Z caller=helm.go:69 component=helm version=v3 info="creating upgraded release for frontend" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:17.984720645Z caller=helm.go:69 component=helm version=v3 info="checking 4 resources for changes" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:17.99557795Z caller=helm.go:69 component=helm version=v3 info="Looks like there are no changes for Service \"frontend\"" targetNamespace=microservices-demo release=frontend
ts=2021-05-06T09:44:18.00842142Z caller=helm.go:69 component=helm version=v3 info="Created a new Deployment called \"frontend-hipster\" in microservices-demo\n" targetNamespace=microservices-demo release=frontend
```

Вывод комманды kubectl get canaries
```shell
NAME       STATUS      WEIGHT   LASTTRANSITIONTIME
frontend   Succeeded   0        2021-05-06T12:30:31Z
```

Вывод после успешной выкладки kubectl describe canary
```shell
Events:
Type     Reason  Age                    From     Message
----     ------  ----                   ----     -------
Warning  Synced  9m51s                  flagger  frontend-primary.microservices-demo not ready: waiting for rollout to finish: observed deployment generation less then desired generation
Normal   Synced  9m21s (x2 over 9m51s)  flagger  all the metrics providers are available!
Normal   Synced  9m20s                  flagger  Initialization done! frontend.microservices-demo
Normal   Synced  4m21s                  flagger  New revision detected! Scaling up frontend.microservices-demo
Normal   Synced  3m51s                  flagger  Starting canary analysis for frontend.microservices-demo
Normal   Synced  3m51s                  flagger  Advance frontend.microservices-demo canary iteration 1/1
Normal   Synced  3m21s                  flagger  Routing all traffic to canary
Normal   Synced  2m51s                  flagger  Copying frontend.microservices-demo template spec to frontend-primary.microservices-demo
Normal   Synced  2m21s                  flagger  Routing all traffic to primary
Normal   Synced  111s                   flagger  Promotion completed! Scaling down frontend.microservices-demo
```

</details>
