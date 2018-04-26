ansible nodes -i inventory-hosts --private-key $AWS_PEM_FILE -m  shell -a 'systemctl restart dbus' 

ansible nodes -i inventory-hosts --private-key $AWS_PEM_FILE -m  shell -a 'systemctl restart dnsmasq'

ansible nodes -i inventory-hosts --private-key $AWS_PEM_FILE -m  shell -a 'systemctl status dnsmasq'

