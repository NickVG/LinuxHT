#! /bin/bash

touch /etc/filebeat/filebeat.yml
cat > /etc/filebeat/filebeat.yml <<EOF
- type: log
 enabled: true
 paths:
 - /var/log/nginx/access.log
 fields:
 service: nginx_access
 fields_under_root: true
 scan_frequency: 5s
EOF
