#!/bin/bash

set -euo pipefail

es_url=http://elastic:${ELASTIC_PASSWORD}@elasticsearch:9200

# Wait for Elasticsearch to start up before doing anything.
until curl -s $es_url -o /dev/null; do
    sleep 1
done

# Setup a license if one is available to use
if [ -n "${ELASTICSEARCH_LICENSE}" ]; then
  echo "${ELASTICSEARCH_LICENSE}" | base64 -d > license.json
  until curl -s -u elastic:${ELASTIC_PASSWORD} http://elasticsearch:9200/_xpack/license?acknowledge=true -H "Content-Type: application/json" -d @license.json ;
  do
    sleep 2
    echo Trying to install elasticsearch license. Retrying...
  done
fi

# Set the password for the kibana user.
# REF: https://www.elastic.co/guide/en/x-pack/6.0/setting-up-authentication.html#set-built-in-user-passwords
until curl -s -H 'Content-Type:application/json' \
     -XPUT $es_url/_xpack/security/user/kibana/_password \
     -d "{\"password\": \"${ELASTIC_PASSWORD}\"}"
do
    sleep 2
    echo Trying to set Kibana password. Retrying...
done
