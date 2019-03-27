#!/bin/bash

echo `gcloud compute instances list --format="value(name,networkInterfaces[0].accessConfigs[0].natIP)"` | while read name1 adr1 name2 adr2;do echo "[ {"\"_meta\"": {"\"hostvars\"": {"\"$name1\"": {"\"ansible_host\"": "\"$adr1\""}, "\"$name2\"": {"\"ansible_host\"": "\"$adr2\""}}}, "\"app\"": {"\"hosts\"":["\"$name1\""]}, "\"db\"": {"\"hosts\"":["\"$name2\""]}} ]" | jq '.[]'; done
