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

#if that doesn't work (put your host names..if using IPs, append .nip.io)
export MASTER=
export INFRA=
export COMPUTE=

export INVENTORY_HOSTS=inventory-hosts

envsubst < inventory-hosts.env > inventory-hosts

./ping-hosts.sh


`````````

prepare the hosts for the install using https://raw.githubusercontent.com/gbengataylor/ocp-ansible-playbooks/master/galaxy-39/prepare_cluster.yml
`````
envsubst < aws-hosts.env > aws-hosts

git clone https://github.com/gbengataylor/ocp-ansible-playbooks.git
cd ocp-ansible-playbooks/galaxy-39
`````
update the hosts file 
`````
ansible-playbook -u ec2-user --private-key $AWS_PEM_FILE  -i ../../aws-hosts prepare_cluster.yml --extra-vars "rhn_user={{ lookup ('env', 'RHSM_USER') }} rhn_pass={{ lookup ('env', 'RHSM_PASS') }} rhn_pool_id={{ lookup ('env', 'POOL_ID') }} ocp_repos=rhel-7-server-ose-3.9-rpms"

cd ../..
`````

Install OpenShift
--------------------------
```
./pre-work.sh
./install.sh
```
Things may go wrong during the install. If it's related to DNS then run
```
./fix-dns.sh
```
then re-execute the install.sh script

Post install
--------------
create users
example-roles
create-pvs (not working)

To uninstal
----------------
```
./uninstall.sh

#optional, remove pre-reqs

ansible-playbook -u ec2-user --private-key $AWS_PEM_FILE  -i ./aws-hosts ocp-ansible-playbooks/galaxy-39/unprepare-cluster.yaml --extra-vars "uninstall_3rdparty=true"

```
