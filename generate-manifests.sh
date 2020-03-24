#!/bin/bash

# manifest / ignition creation prep
rm -rf bootstrap-files/
mkdir -p bootstrap-files
cp install-config.yaml bootstrap-files/
cp append-bootstrap.ign bootstrap-files/
cd bootstrap-files

# create kubernetes manifests
openshift-install create manifests

# ensure masters are not schedulable
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' manifests/cluster-scheduler-02-config.yml

# create ignition config files
openshift-install create ignition-configs

# copy new ignition bootstrap file to webserver
# replace 192.168.1.160 with IP of your load balancer/webserver node
ssh root@192.168.1.160 mkdir -p /var/www/html/ignition/
ssh root@192.168.1.160 rm /var/www/html/ignition/bootstrap.ign
scp bootstrap.ign  root@192.168.1.160:/var/www/html/ignition/
ssh root@192.168.1.160 chmod 777 /var/www/html/ignition/bootstrap.ign

# base64 encode ignition files for vmware
for i in append-bootstrap master worker
do
base64 -w0 < $i.ign > $i.64
done

# reads base64 encoding strings to variables for use in the next step
bootstrapign=`cat append-bootstrap.64`
masterign=`cat master.64`
workerign=`cat worker.64`

# update newly created ignition URL in tf vars files
sed -i '/\#base64string/!b;n;c\ \ \ \ default = "'$bootstrapign'"' ../terraform/bootstrap/variables.tf
sed -i '/\#base64string/!b;n;c\ \ \ \ default = "'$masterign'"' ../terraform/masters/variables.tf
sed -i '/\#base64string/!b;n;c\ \ \ \ default = "'$workerign'"' ../terraform/workers/variables.tf