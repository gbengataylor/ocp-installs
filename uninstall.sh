ansible-playbook -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
ansible-playbook -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE remove-mnts.yml
