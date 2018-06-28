#!/bin/bash

set -euo pipefail

ES_URL=${ES_URL:-http://elastic:${ELASTIC_PASSWORD}@elasticsearch:9200}
ELASTICSEARCH_LICENSE=${ELASTICSEARCH_LICENSE:-}

# Wait for Elasticsearch to start up before doing anything.
until curl -s $ES_URL -o /dev/null; do
    sleep 1
done

# Setup a license if one is available to use
if [ -n "${ELASTICSEARCH_LICENSE}" ]; then
  echo "${ELASTICSEARCH_LICENSE}" | base64 -d > license.json
  until curl -s -u elastic:${ELASTIC_PASSWORD} ${ES_URL}/_xpack/license?acknowledge=true -H "Content-Type: application/json" -d @license.json ;
  do
    sleep 2
    echo Trying to install elasticsearch license. Retrying...
  done
fi

# 6.3.0 and later do this:
if [ -n "${INSTALL_BASIC_ELASTICSEARCH_LICENSE}" ]; then
  curl -s -u elastic:${ELASTIC_PASSWORD} ${ES_URL}/_xpack/license/start_basic -H "Content-Type: application/json" || true
fi

# Set the password for the kibana user.
# REF: https://www.elastic.co/guide/en/x-pack/6.0/setting-up-authentication.html#set-built-in-user-passwords
until curl -s -H 'Content-Type:application/json' \
     -XPUT $ES_URL/_xpack/security/user/kibana/_password \
     -d "{\"password\": \"${ELASTIC_PASSWORD}\"}"
do
    sleep 2
    echo Trying to set Kibana password. Retrying...
done
