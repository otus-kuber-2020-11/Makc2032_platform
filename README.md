# Makc2032_platform
Makc2032 Platform repository

#Custom Resource Definitions. Operators
Вывод команды kubectl get jobs:

NAME                         COMPLETIONS   DURATION   AGE
backup-mysql-instance-job    1/1           2s         7m27s
restore-mysql-instance-job   1/1           46s        6m12s

Вывод при запущенном MySQL:
mysql: [Warning] Using a password on the command line interface can be insecure.
+----+-------------+
| id | name        |
+----+-------------+
|  1 | some data   |
|  2 | some data-2 |
+----+-------------+
