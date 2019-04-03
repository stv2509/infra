#!/bin/bash
if gcloud compute firewall-rules list --format=json | grep ssh
then
	echo -e "\n #######- Firewall-rules \"default-allow-ssh\" alredy nstall -#######"
else
	echo -e "#######- INSTALL default-allow-ssh -#######\n"
	gcloud compute firewall-rules create default-allow-ssh \
 --allow tcp:22 --priority=65534 \
 --description="Allows SSH connections" \
 --direction=INGRESS
	echo -e "\n#######- Installation completed -#######"
fi
