#!/bin/bash


#Checked: Xenial & Juju 2.2.4/Update:2017/9/21
#Checked: Xenial & Juju 2.0.2/Update:2017/9/15
case $1 in
1 ) juju status --format tabular;;
2 ) juju models;;
4 )
wait1="sleep 10m"
#wait1="echo 'Next>Press Enter Key'&&read"

# Debug
#juju debug-log --replay --level WARNING 2>&1|tee -a openstack-deperr.out &

# Deploy the OpenStack Charms
juju deploy --config openstack.yaml cs:xenial/neutron-gateway-238 --to 1
#eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/nova-compute-273 --to 2
eval ${wait1}

juju deploy cs:xenial/rabbitmq-server-65 --to lxd:0 &&
juju add-unit rabbitmq-server --to lxd:1
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/nova-cloud-controller-300 --to lxd:0
eval ${wait1}

#juju deploy --config openstack.yaml cs:xenial/mysql-57 --to lxd:0
juju deploy --config openstack.yaml percona-cluster --to lxd:1 &&
juju add-unit -n1 percona-cluster --to lxd:2 &&
juju config percona-cluster min-cluster-size=2
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/glance-259 --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/keystone-268 --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/openstack-dashboard-250 --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/neutron-openvswitch
#eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/neutron-api-252  --to lxd:1
eval ${wait1}


echo "EOF"
;;
* ) echo "Set the 1 - 4. 1:View Status/2:View Models/4:Deploy the OpenStack";;
esac
