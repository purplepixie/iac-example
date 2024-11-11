# Infrastructure as Code Example

## Terraform Google Cloud Platform (gcp/)

Contains a ```main.tf``` (requires ```servicekey.json```) which provisions a VM on GCP and returns the IP address.

## Terrform and Ansible Google Cloud Platform (gcp-ansible/)

Contains:
* ```main.tf``` (requires ```servicekey.json```) which provisions a VM on GCP open to incoming HTTP connections.
* ```nginx_install.yml``` an Ansible playbook that checks nginx is at the latest version and started.
* ```run-ansible.sh``` to run the playbook using the IP output from terraform
* ```provision.sh``` to stand up the terraform environment and then run the playbook (full provisioning)

## Kubernetes (k8s/)

Contains a ```kubernetes.tf``` which uses the local kubeconfig to provision a ```rancher/hello-world``` service on QPC with services and ingress in the ```davedemo``` namespace.
