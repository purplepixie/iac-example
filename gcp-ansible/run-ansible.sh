ansible-playbook -i `terraform output -json ip | jq -r`, nginx_install.yml -b
