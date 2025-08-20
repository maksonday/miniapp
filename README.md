# miniapp

## Установка и запуск

Перед запуском обязательно нужны:

1) Секрет с паролем для БД PostgreSQL, например:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  postgres-password: UXdlcnR5MTIzNCFA
```

2) Секрет с паролем от Redis, например:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: redis-secret
type: Opaque
data:
  redis-password: UXdlcnR5MTIzNCFA
```

3) Секрет с приватными и публичным ключами для сервиса аутентификации, например:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: rsa-cert
type: Opaque
data:
  private-key: |
    ...

  public-key: |
    ...
```


Секреты должен находиться в том же namespace, что и устанавливаемый chart

```bash
helm repo add miniapp https://maksonday.github.io/miniapp/
helm install miniapp -n miniapp miniapp/miniapp --set postgresql.auth.existingSecret=postgres-secret --set redis.auth.existingSecret=redis-secret --set auth.existingSecret=rsa-cert --set redis.auth.existingSecretPasswordKey=redis-password
```

## Тестирование

```bash
newman run miniapp/tests/auth_and_api_postman_collection.json
```