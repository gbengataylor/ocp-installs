ansible-playbook -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
