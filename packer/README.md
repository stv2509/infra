packer:
gcloud compute instances create reddit-app --boot-disk-size=10GB --image=reddit-base-1550235774 --image-project=week-3-231412 --machine-type=g1-small --tags infra-server --restart-on-failure --zone=europe-west1-b --metadata startup-script='wget -O - https://raw.githubusercontent.com/stv2509/infra/config-scripts/deploy.sh| bash'
packer validate -var-file=variables.json ubuntu16.json
packer build -var-file=variables.json ubuntu16.json

Если в процессе создания packer не может подключиться к образу, проверьте что создано правило "firewall_ssh" в GCP.
