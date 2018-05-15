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

logging:
  loglevel: DEBUG
  logfile:
  logformat: default
#  blacklist: ['elasticsearch', 'urllib3']
EOF

cat /root/.curator/curator.yml

cat <<EOF > /root/.curator/safehouse.yml
---
actions:
  1:
    action: snapshot
    description: >-
      Snapshot alexa-trigger events from safehouse
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: alexa-trigger_%Y%m%d%H%M%S
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
        value: alexa-trigger

  2:
    action: snapshot
    description: >-
      Snapshot alexa-music events from safehouse
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: alexa-music_%Y%m%d%H%M%S
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
        value: alexa-music

  3:
    action: snapshot
    description: >-
      Snapshot door-lock events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: door-lock_%Y%m%d%H%M%S
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
        value: door-lock

  4:
    action: snapshot
    description: >-
      Snapshot domoticz events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: domoticz_%Y%m%d%H%M%S
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
        value: domoticz

  5:
    action: snapshot
    description: >-
      Snapshot gammarf events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: gammarf_%Y%m%d%H%M%S
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
        value: gammarf

  6:
    action: snapshot
    description: >-
      Snapshot google-home events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: google-home_%Y%m%d%H%M%S
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
        value: google-home

  7:
    action: snapshot
    description: >-
      Snapshot IFTTT events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: ifttt_%Y%m%d%H%M%S
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
        value: ifttt

  8:
    action: snapshot
    description: >-
      Snapshot logstash events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: logstash_%Y%m%d%H%M%S
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
        value: logstash

  9:
    action: snapshot
    description: >-
      Snapshot minicam-motion events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: minicam-motion_%Y%m%d%H%M%S
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
        value: minicam-motion

  10:
    action: snapshot
    description: >-
      Snapshot motion events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: motion_%Y%m%d%H%M%S
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
        value: motion

  11:
    action: snapshot
    description: >-
      Snapshot pcap events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: pcap_%Y%m%d%H%M%S
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
        value: pcap

  12:
    action: snapshot
    description: >-
      Snapshot plc-remote-access events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: plc-remote-access_%Y%m%d%H%M%S
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
        value: plc-remote-access

  13:
    action: snapshot
    description: >-
      Snapshot plug events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: plug_%Y%m%d%H%M%S
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
        value: plug

  14:
    action: snapshot
    description: >-
      Snapshot safehouse-ap-devices events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: safehouse-ap-devices_%Y%m%d%H%M%S
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
        value: safehouse-ap-devices
  15:
    action: snapshot
    description: >-
      Snapshot safehouse-ap-ssh events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: safehouse-ap-ssh_%Y%m%d%H%M%S
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
        value: safehouse-ap-ssh

  16:
    action: snapshot
    description: >-
      Snapshot watcher events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: watcher_%Y%m%d%H%M%S
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
        value: watcher

  17:
    action: snapshot
    description: >-
      Snapshot webcam-pcap events
    options:
      repository: ${ES_S3_REPOSITORY_NAME}
      name: webcam-pcap_%Y%m%d%H%M%S
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
        value: webcam-pcap
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

while true; do
  curator --config curator.yml safehouse.yml
  sleep ${SLEEP:-86400}
done

wait
