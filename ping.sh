#!/bin/bash

## NOT COMPLETE SCRIPT, just to show that maybe how the ping scenario can work with terraform output.

from_instance_ping_ip=$1
instance_to_ping_ip=$2

ssh -o 'StrictHostKeyChecking no' "ubuntu@$from_instance_ping_ip" << EOF
ping -q -c 1  "$instance_to_ping_ip" 2>&1 > /dev/null && status=SUCCESS || status=FAILED",
EOF

# produce json to used by external data source
