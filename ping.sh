#!/bin/bash

bastion_ip=""
bastion_private_key=""
number_of_instances=""
instances_ips=""

# wait 30 second so all instances are ready
sleep 30

eval "$(jq -r \
'@sh
"number_of_instances=\(.number_of_instances)
bastion_ip=\(.bastion_ip)
bastion_private_key=\(.bastion_private_key)
instances_ips=\(.instances_ips)"')"

# convert list of ips to bash array
IFS=', ' read -r -a instances_ips <<< "$instances_ips"

# Add bastion ssh key to the agent store and known hosts
echo "$bastion_private_key" | tr -d '\r' | ssh-add -
ssh-keyscan -H "$bastion_ip" >> ~/.ssh/known_hosts

printf "{"
for i in $(seq 0 $((${number_of_instances}-1)));
do
     if [[ $i = $((${number_of_instances}-1)) ]];
     then
          rb_index=0
          ssh -T -o StrictHostKeyChecking=no -o AddKeysToAgent=yes -J "ubuntu@$bastion_ip" \
          "ubuntu@${instances_ips[$i]}" 'exec bash' <<EOF
            ping -c 1 "${instances_ips[$rb_index]}" 2>&1 > /dev/null \
            && printf '"'"instance${i}"'":"{ping_to:'"instance${rb_index}"',ping_status:SUCCESS}"' \
            || printf '"'"instance${i}"'":"{ping_to:'"instance${rb_index}"',ping_status:FAILED}"'
EOF
     else
          rb_index=$((i+1))
          ssh -T -o StrictHostKeyChecking=no -o AddKeysToAgent=yes -J "ubuntu@$bastion_ip" \
          "ubuntu@${instances_ips[$i]}" 'exec bash' <<EOF
            ping -c 1 "${instances_ips[$rb_index]}" 2>&1 > /dev/null \
            && printf '"'"instance${i}"'":"{ping_to:'"instance${rb_index}"',ping_status:SUCCESS}",' \
            || printf '"'"instance${i}"'":"{ping_to:'"instance${rb_index}"',ping_status:FAILED}",'
EOF
     fi
done
printf "}\n"
