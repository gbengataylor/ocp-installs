#login as system admin first to the master
oc adm policy add-cluster-role-to-user cluster-admin system
oc adm policy add-cluster-role-to-user cluster-admin admin

oc adm policy add-role-to-user cluster-admin system --config=/etc/origin/master/admin.kubeconfig 
oc adm policy add-role-to-user cluster-admin admin  --config=/etc/origin/master/admin.kubeconfig 


oc adm policy add-role-to-user admin system -n default

oc adm policy add-role-to-user admin system -n kube-public

oc adm policy add-role-to-user admin system -n kube-service-catalog

 oc adm policy add-role-to-user admin system -n kube-system

 oc adm policy add-role-to-user admin system -n logging

 oc adm policy add-role-to-user admin system -n management-infra

 oc adm policy add-role-to-user admin system -n openshift

 oc adm policy add-role-to-user admin system -n openshift-ansible-service-broker

 oc adm policy add-role-to-user admin system -n openshift-infra

 oc adm policy add-role-to-user admin system -n openshift-node

 oc adm policy add-role-to-user admin system -n openshift-template-service-broker


