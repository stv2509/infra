This is infrastructure repository.

gcloud compute instances create myreddit-app --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20190212 --image-project=ubuntu-os-cloud --machine-type=g1-small --tags infra-server --restart-on-failure --zone=europe-west1-b --metadata startup-script='wget -O - https://raw.githubusercontent.com/stv2509/infra/config-scripts/startup_puma.sh | bash'


packer:
gcloud compute instances create reddit-app --boot-disk-size=10GB --image=reddit-base-1550235774 --image-project=week-3-231412 --machine-type=g1-small --tags infra-server --restart-on-failure --zone=europe-west1-b --metadata startup-script='wget -O - https://raw.githubusercontent.com/stv2509/infra/config-scripts/deploy.sh| bash'
