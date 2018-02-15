#!/bin/bash
# Call import-certs.sh before executing CMD or COMMAND
/usr/local/bin/import-certs.sh

exec "$@"
