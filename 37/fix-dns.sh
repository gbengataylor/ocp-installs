ansible nodes -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE -m  shell -a 'systemctl restart dbus' 

ansible nodes -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE -m  shell -a 'systemctl restart dnsmasq'

ansible nodes -i $INVENTORY_HOSTS --private-key $AWS_PEM_FILE -m  shell -a 'systemctl status dnsmasq'

