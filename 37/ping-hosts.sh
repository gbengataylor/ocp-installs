#do this to make sure they all work
ansible all -i inventory-hosts --private-key $AWS_PEM_FILE -m ping
