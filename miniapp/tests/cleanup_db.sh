PGPASSWORD=$(kubectl -n miniapp get secrets/postgres-secret --template='{{ index .data "postgres-password" | base64decode }}')
kubectl exec -it miniapp-postgresql-primary-0 -n miniapp -- bash -c "/opt/bitnami/scripts/postgresql/entrypoint.sh -- bash -c 'PGPASSWORD=$PGPASSWORD psql miniapp -c \"
truncate table stock_changes restart identity;
truncate table stock restart identity;
truncate table items restart identity;
truncate table payments restart identity;
truncate table orders restart identity;
truncate table notifications restart identity;
truncate table couriers restart identity;
truncate table courier_schedule restart identity;
truncate table courier_reservation restart identity;
update accounts set balance = 0;\"'"