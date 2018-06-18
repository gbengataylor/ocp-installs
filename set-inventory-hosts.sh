export MASTER=18.191.88.27.nip.io
export INFRA=18.191.104.127.nip.io
export COMPUTE=18.222.98.180.nip.io 
#if master is same as nfs
#export NFS=18.191.88.27.nip.io
#if different nfs
export NFS=18.219.48.6

#export INVENTORY_HOSTS=inventory-hosts-dns
export INVENTORY_HOSTS=inventory-hosts
echo $INVENTORY_HOSTS
echo $MASTER
echo $INFRA
echo $COMPUTE
echo $NFS
