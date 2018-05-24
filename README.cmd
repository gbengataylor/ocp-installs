Note: this is the readme for OCP 3.7 Origin not the product

see openshift-ansible-playbooks.info

for 37, using https://github.com/openshift/openshift-ansible/tree/release-3.7/playbooks
git clone https://github.com/openshift/openshift-ansible/tree/release-3.7/playbooks
cd openshift-ansible
git checkout release-3.7
cd ..


order
fix-control-node
set-inventory-hosts
ping-hosts
prepare the hosts for the install using https://raw.githubusercontent.com/gbengataylor/ocp-ansible-playbooks/master/galaxy/prepare_cluster.yml
pre-work
install

#maybe
example-roles
create-pvs (not working)

#uninstall
uninstall
