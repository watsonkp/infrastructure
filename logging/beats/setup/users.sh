#!/bin/sh
set -xe

# Create a role containing the permissions beyond other roles that are required to setup filebeat.
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/role/filebeat_setup -d '{ "cluster": [ "monitor", "manage_ilm" ], "indices": [ { "names": [ "filebeat-*" ], "privileges": [ "manage" ] } ] }'

# Create a user with the roles required to setup ElasticSearch and Kibana for FileBeat.
# Reference: https://www.elastic.co/guide/en/beats/filebeat/current/privileges-to-setup-beats.html
curl -sS --cacert /container/certs/elasticsearch-ca.pem -i -w '\n' -X POST -u elastic:$ELASTIC_PASSWORD -H "Content-Type: application/json" https://elasticsearch:9200/_security/user/filebeat_installer -d "{ \"password\": \"$FILEBEAT_INSTALLER_PASSWORD\", \"roles\": [ \"filebeat_setup\", \"kibana_admin\", \"ingest_admin\" ], \"full_name\": \"FileBeat Installer\", \"email\": \"user@example.com\" }"
