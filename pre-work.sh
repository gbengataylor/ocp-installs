ansible-playbook -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE  create-export-dir.yaml ! [ $? == 0 ] && echo " CREATE EXPORT FAILED" && exit 1 
ansible-playbook -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE  /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml ! [ $? == 0 ] && echo "PREREQ FAILED" && exit 1
