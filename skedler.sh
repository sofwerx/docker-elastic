#!/bin/bash

cat <<EOF > /opt/skedler/config/reporting.yml
# Kibana url specification
Kibana_url: ${KIBANA_URL}
 
# Kibana Display url specification
Kibana_display_url: ${KIBANA_URL}
 
# The Elasticsearch instance to use for all your queries.
elasticsearch_url: ${ELASTIC_URL}

# If kibana shield plugin is installed in Kibana please set this variable as "yes".
# Kibana shield plugin is installed in kibana to connect to elasticsearch shield.
# If kibana doesn't have shield plugin and elasticsearch is configured with shield, set this variable to no and please set the next section

kibana_shield_plugin: no

# If Elastic search uses shield or basic auth, add the shield user name and password here for skedler
skedler_elasticsearch_username: ${ELASTIC_USER}
skedler_elasticsearch_password: ${ELASTIC_PASSWORD}

# If Elastic search uses shield or basic auth, add the shield user name and password here for kibana
kibana_elasticsearch_username: ${ELASTIC_USER}
kibana_elasticsearch_password: ${ELASTIC_PASSWORD}

# Nginx Support
# If kibana behind Nginx, configure Ngnix username password for kibana here
skedler_nginx_kibana_username: ${ELASTIC_USER}
skedler_nginx_kibana_password: ${ELASTIC_PASSWORD}

# If elasticsearch behind Ngnix, configure Ngnix username password for elasticsearch here
skedler_nginx_elasticsearch_username: ${ELASTIC_USER}
skedler_nginx_elasticsearch_password: ${ELASTIC_PASSWORD}

# Grafana URL
#grafana_url: "http://localhost:3000"

# Grafana authentication to access the dashboard
#skedler_grafana_username: user
#skedler_grafana_password: pass

# Grafana authentication token key
#grafana_auth_token_key: ''

# Persistence Folder
# Note: Please don't use the ui_files_location for reports_dir, log_dir or to store anything else.
#ui_files_location: "/opt/skedlerfiles"

# Reports home directory
#reports_dir: "/opt/skedlerreports"

# Log home directory
#log_dir: "/opt/skedlerlog"

# Enables SSL and paths to the PEM-format SSL certificate and SSL key files, respectively.
# These settings enable SSL for outgoing requests from the Kibana server to the browser.
#server_ssl_enabled: true
#server_ssl_certificate: /path/to/your/server.crt
#server_ssl_key: /path/to/your/server.key

# Optional settings that provide the paths to the PEM-format SSL certificate and key files.
# These files validate that your Elasticsearch backend uses the same key files.
#enable_elasticsearch_ssl: true
#elasticsearch_ssl_certificate: /path/to/your/client.crt
#elasticsearch_ssl_key: /path/to/your/client.key

# Optional setting that enables you to specify a path to the PEM file for the certificate
# authority for your Elasticsearch instance.
#elasticsearch_ssl_certificateAuthorities: [ "/path/to/your/CA.pem" ]

# To disregard the validity of SSL certificates, change this setting's value to 'none'.
#elasticsearch_ssl_verificationMode: full

# Elasticsearch ping timeout setting in milliseconds
#pingTimeout: 1500

# Elasticsearch request timeout setting in milliseconds
# This must be > 0
#requestTimeout: 300000
EOF

cd /opt/skedler
exec ./bin/skedler debug $@
