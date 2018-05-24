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

#Before doing this make sure your inventory-hosts.env file has all the settings you need 

envsubst < inventory-hosts.env > inventory-hosts

./ping-hosts.sh


`````````

prepare the hosts for the install using https://raw.githubusercontent.com/gbengataylor/ocp-ansible-playbooks/master/galaxy-39/prepare_cluster.yml
`````
#update the aws-hosts.env file if installing HA cluster
envsubst < aws-hosts.env > aws-hosts

git clone https://github.com/gbengataylor/ocp-ansible-playbooks.git
cd ocp-ansible-playbooks/galaxy-39

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
then re-execute the install.sh script. If you need to fix the inventory file, modify inventory-hosts.env and re-run
```
envsubst < inventory-hosts.env > inventory-hosts

```

Post install
--------------
We need to create users, associate the appropriate roles, and create persistent volumes. For now, this is run manaully on the master, so you have to SSH to the master.

TODO: create ansible playbook to do this from control node


```
#modify accordingly
export ADMIN_USER=admin
export ADMIN_PASS=
export SYS_ADMIN_USER=system
export USERNAME=developer
export PASSWORD=

yum install  httpd-tools
htpasswd -b /etc/origin/master/htpasswd ${ADMIN_USER} ${ADMIN_PASS}
htpasswd -b /etc/origin/master/htpasswd ${SYS_ADMIN_USER} ${ADMIN_PASS}
oc adm policy add-cluster-role-to-user cluster-admin ${ADMIN_USER}
oc adm policy add-cluster-role-to-user cluster-admin ${SYS_ADMIN_USER}

htpasswd -b /etc/origin/master/htpasswd ${USERNAME} ${PASSWORD}
systemctl restart atomic-openshift-master-api

for i in {0..9}
do
	DIRNAME=$(printf "vol%02d" $i)
	mkdir -p /mnt/data/$DIRNAME
        chmod a+rwx /mnt/data/$DIRNAME
	chcon -Rt svirt_sandbox_file_t /mnt/data/$DIRNAME
done

#login into openshift
oc login $MASTER:8443 -u $ADMIN_USER -p $ADMIN_PASS

wget https://raw.githubusercontent.com/gbengataylor/ocp-installs/3.9/vol.yaml

for i in {0..9}
do
	DIRNAME=$(printf "vol%02d" $i)
	sed -i "s/name: vol..*/name: $DIRNAME/g" vol.yaml
	sed -i "s/path: \/mnt\/data\/vol..*/path: \/mnt\/data\/$DIRNAME/g" vol.yaml
	oc create -f vol.yaml
	echo "created volume $i"
done
```

To uninstal
----------------
```
./uninstall.sh

#optional, remove pre-reqs

ansible-playbook -u ec2-user --private-key $AWS_PEM_FILE  -i ./aws-hosts ocp-ansible-playbooks/galaxy-39/unprepare-cluster.yaml --extra-vars "uninstall_3rdparty=true"

```
