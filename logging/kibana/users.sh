#!/bin/sh
set -xe

# Enable the kibana-system user for the Kibana server by setting a password.
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/user/kibana_system/_password -d "{ \"password\": \"$KIBANA_SYSTEM_PASSWORD\" }"

# Create a user with the kibana_admin role for human administration of Kibana.
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/user/kibana_administrator -d "{ \"password\": \"$KIBANA_ADMINISTRATOR_PASSWORD\", \"roles\": [ \"kibana_admin\" ], \"full_name\": \"Kibana Administrator\", \"email\": \"user@example.com\" }"
