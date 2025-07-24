# miniapp

## Установка и запуск

Перед запуском обязательно нужен секрет с паролем для БД, например:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  postgres-password: UXdlcnR5MTIzNCFA
```

Секрет должен находиться в том же namespace, что и устанавливаемый chart

```bash
helm repo add maksonday https://maksonday.github.io/miniapp/
helm install users-crud --set postgresql.auth.existingSecret=postgres-secret maksonday/users-crud -n minapp
```