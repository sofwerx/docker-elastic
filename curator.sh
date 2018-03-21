#!/bin/bash

set -exo pipefail

mkdir -p /root/.curator

cat <<EOF > /root/.curator/curator.yml
client:
  hosts:
    - ${ES_HOST}
  port: ${ES_PORT}
  url_prefix:
  use_ssl: False
  certificate:
  client_cert:
  client_key:
  ssl_no_validate: False
  http_auth: ${ES_USER}:${ES_PASS}
  timeout: 30
  master_only: False

logging:
  loglevel: DEBUG
  logfile:
  logformat: default
  blacklist: ['elasticsearch', 'urllib3']
EOF

cat <<EOF > /root/.curator/delete.yml
---
actions:
  1:
    action: delete_indices
    description: >-
      Delete indices older than 7 days (based on index name), for pcap-
      prefixed indices. Ignore the error if the filter does not result in an
      actionable list of indices (ignore_empty_list) and exit cleanly.
    options:
      ignore_empty_list: true
      disable_action: false
    filters:
      - filtertype: pattern
        kind: prefix
        value: pcap-
      - filtertype: age
        source: name
        direction: older
        timestring: '%Y-%m-%d'
        unit: days
        unit_count: 7
EOF

while true; do
  curator --config curator.yml delete.yml
  sleep ${SLEEP:-300}
done

