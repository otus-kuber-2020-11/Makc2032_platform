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
