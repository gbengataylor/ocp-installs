Note: Assumes there is 1 master, 1 infra, 1 compute. But this can easily be modified for an HA env

Download RPMs to control/install host
---------------------------------------
`````````
#update as needed
export $RHSM_USER=
export $RHSM_PASS=

subscription-manager register --username=$RHSM_USER --password=$RHSM_PASS
if [ -z "$POOL_ID" ]
then
    POOL_ID=$(subscription-manager list --available | \
        grep 'Subscription Name\|Pool ID' | \
        grep -A1 'OpenShift Employee Subscription' | \
        grep 'Pool ID' | awk '{print $NF}')
fi

subscription-manager attach --pool=$POOL_ID
subscription-manager repos --disable='*'
subscription-manager repos \
    --enable=rhel-7-server-rpms \
    --enable=rhel-7-server-extras-rpms \
    --enable=rhel-7-server-ose-3.9-rpms \
    --enable=rhel-7-fast-datapath-rpms \
    --enable=rhel-7-server-ansible-2.4-rpms
    
yum -y install atomic-openshift-utils  atomic
`````````
The directory /usr/share/ansible/openshift-ansible/ should now exist

Prep the control node and prepare the target hosts
---------------

`````````
#modify as needed
echo AWS_PEM_FILE= 

./fix-control-node.sh

#before running this, make sure to set the appropriate env variables in the files for the master, infra and compute nodes
./set-inventory-hosts.sh
./ping-hosts.sh
`````````

prepare the hosts for the install using https://raw.githubusercontent.com/gbengataylor/ocp-ansible-playbooks/master/galaxy-39/prepare_cluster.yml
`````
git clone https://github.com/gbengataylor/ocp-ansible-playbooks.git
cd ocp-ansible-playbooks/galaxy-39
`````
update the hosts file 
`````
ansible-playbook -u ec2-user --private-key $AWS_PEM_FILE  -i ./hosts prepare_cluster.yml --extra-vars "rhn_user={{ lookup ('env', 'RH_USER') }} rhn_pass={{ lookup ('env', 'RH_PASS') }} rhn_pool_id={{ lookup ('env', 'RH_POOL') }} ocp_repos=rhel-7-server-ose-3.9-rpms cluster_name=ocp-cluster"
cd ..
`````

pre-work
install

#maybe
example-roles
create-pvs (not working)

To uninstal
----------------
#uninstall
uninstall
