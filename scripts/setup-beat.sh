#!/bin/bash

set -euo pipefail

beat=$1

KIBANA_HOST=${KIBANA_HOST:-kibana}
KIBANA_URL=${KIBANA_URL:-http://${KIBANA_HOST}:5601}
ELASTIC_USER=${ELASTIC_USER:-elastic}

until curl -s ${KIBANA_URL} 2>&1 > /dev/null; do
    sleep 2
done
sleep 5

# Load the sample dashboards for the Beat.
# REF: https://www.elastic.co/guide/en/beats/metricbeat/master/metricbeat-sample-dashboards.html
${beat} setup \
        -E "setup.kibana.host=${KIBANA_HOST}" \
        -E "setup.kibana.username=${ELASTIC_USER}" \
        -E "setup.kibana.password=${ELASTIC_PASSWORD}" \
        -E "xpack.monitoring.elasticsearch.url=${XPACK_MONITORING_ELASTICSEARCH_URL}" \
        -E "xpack.monitoring.elasticsearch.username=${XPACK_MONITORING_ELASTICSEARCH_USERNAME}" \
        -E "xpack.monitoring.elasticsearch.password=${XPACK_MONITORING_ELASTICSEARCH_PASSWORD}" \
        -E "output.elasticsearch.username=${ELASTIC_USER}" \
        -E "output.elasticsearch.password=${ELASTIC_PASSWORD}" \
        -E "output.elasticsearch.hosts=${OUTPUT_ELASTICSEARCH_HOSTS}" 
