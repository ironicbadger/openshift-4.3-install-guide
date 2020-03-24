init:
	cd terraform/bootstrap; terraform init
	cd terraform/loadbalancer; terraform init
	cd terraform/masters; terraform init
	cd terraform/workers; terraform init
	cd ansible; ansible-galaxy install -r requirements.yaml

create-everything:
	cd terraform/loadbalancer; terraform apply
	cd ansible; ansible-playbook -u root -i hosts.ini site.yaml
	./generate-manifests.sh
	cd terraform/bootstrap; terraform apply -auto-approve
	cd terraform/masters; terraform apply -auto-approve
	cd terraform/workers; terraform apply -auto-approve

destroy-everything:
	cd terraform/bootstrap; terraform destroy
	cd terraform/workers; terraform destroy -auto-approve
	cd terraform/masters; terraform destroy -auto-approve
	cd terraform/loadbalancer; terraform destroy -auto-approve
	rm -rf bootstrap-files/

create-lb:
	cd terraform/loadbalancer; terraform apply
	cd ansible; ansible-playbook -u root -i hosts.ini site.yaml

recreate-lb:
	cd terraform/loadbalancer; terraform destroy
	cd terraform/loadbalancer; terraform apply
	cd ansible; ansible-playbook -u root -i hosts.ini site.yaml

destroy-lb:
	cd terraform/loadbalancer; terraform destroy

create-bootstrap:
	cd terraform/bootstrap; terraform apply

recreate-bootstrap:
	cd terraform/bootstrap; terraform destroy
	cd terraform/bootstrap; terraform apply

destroy-bootstrap:
	cd terraform/bootstrap; terraform destroy

create-masters:
	cd terraform/masters; terraform apply

recreate-masters:
	cd terraform/masters; terraform destroy
	cd terraform/masters; terraform apply

destroy-masters:
	cd terraform/masters; terraform destroy

create-workers:
	cd terraform/workers; terraform apply

recreate-workers:
	cd terraform/workers; terraform destroy
	cd terraform/workers; terraform apply

destroy-workers:
	cd terraform/workers; terraform destroy

wait-for-bootstrap:
	cd bootstrap-files; openshift-install wait-for install-complete --log-level debug

wait-for-install:
	cd bootstrap-files; openshift-install wait-for install-complete --log-level debug

