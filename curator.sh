#!/bin/bash
set -x

if [ -n "${ES_S3_REPOSITORY_NAME}" ]; then
curl -H "Content-Type: application/json" -XGET -u ${ES_USER}:${ES_PASS} $ES_URL'/_snapshot/'${ES_S3_REPOSITORY_NAME}
echo ""
curl -H "Content-Type: application/json" -XPUT -u ${ES_USER}:${ES_PASS} $ES_URL'/_snapshot/'${ES_S3_REPOSITORY_NAME} --data-binary @- <<EOF
{
    "type" : "s3",
    "settings" : {
      "bucket" : "${ES_S3_REPOSITORY_BUCKET}",
      "region": "${AWS_REGION}",
      "base_path": "/elasticsearch/",
      "compress": true,
      "server_side_encryption": true,
      "role_arn ": "arn:aws:iam::094013511888:role/swx-blueteam-instance_role"
     }
}
EOF
fi

echo ""

mkdir -p /root/.curator

cat <<EOF > /root/.curator/curator.yml
client:
  hosts:
    - ${ES_HOST}
  port: ${ES_PORT}
  url_prefix:
  use_ssl: True
  certificate:
  client_cert:
  client_key:
  ssl_no_validate: False
  http_auth: ${ES_USER}:${ES_PASS}
  timeout: 30
  master_only: False
  aws_region: ${AWS_REGION}
  aws_sign_request: True

logging:
  loglevel: DEBUG
  logfile:
  logformat: default
  blacklist: ['elasticsearch', 'urllib3']
EOF

cat /root/.curator/curator.yml

cat <<EOF > /root/.curator/snapshot.yml
---
actions:
  1:
    action: snapshot
    description: >-
      Snapshot selected indices to 'repository' with the snapshot name or name
      pattern in 'name'.  Use all other options as assigned
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      # Leaving name blank will result in the default 'curator-%Y%m%d%H%M%S'
      name: curator-%Y%m%d%H%M%S
      continue_if_exception: False
      disable_action: False
      ignore_unavailable: False
      include_global_state: True
      max_wait: 3600
      partial: False
      skip_repo_fs_check: False
      timeout_override:
      wait_for_completion: True
      wait_interval: 10

    filters:
      - filtertype: pattern
        kind: prefix
        value: webcam-
EOF

if [ -n "${DELETE_INDEXES}" ]; then
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
fi

cd /root/.curator

exec  curator --config curator.yml snapshot.yml --dry-run

while true; do

  #curator --config curator.yml delete.yml
  sleep ${SLEEP:-300}
done

