#!/bin/sh
set -xe

# Create a role allowing a user to write to LogStash related ElasticSearch indices.
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/role/logstash_writer -d '{ "cluster": [ "monitor", "manage_index_templates", "manage_ilm" ], "indices": [ { "names": [ "filebeat-*", "logstash-*", "packetbeat-*", "http-*" ], "privileges": [ "write", "create", "create_index", "manage", "manage_ilm" ] } ] }'

# Create a user with the logstash_writer for the LogStash server.
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/user/logstash_publisher -d "{ \"password\": \"$LOGSTASH_PUBLISHER_PASSWORD\", \"roles\": [ \"logstash_writer\" ], \"full_name\": \"Logstash Publisher\", \"email\": \"user@example.com\" }"
