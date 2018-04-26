#do this to make sure they all work
ansible all -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE -m ping
