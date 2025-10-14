newman run miniapp/tests/idempotency_pre_test_checks.postman_collection.json --env-var "baseUrl=arch.homework" --export-environment new_env.json

for i in {1..10}; do
  newman run miniapp/tests/generate_orders.postman_collection.json \
   -e new_env.json | sed -r "s/\x1B\[[0-9;]*[mK]//g" >  "create_order_output_$i.log" 2>&1 &
done
wait

sleep 60

newman run miniapp/tests/idempotency_check.postman_collection.json -e new_env.json