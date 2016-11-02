#!/bin/bash

#For Xenial & Juju 2.0/Update:2016/11/02
case $1 in
1 ) juju status --format tabular;;
2 ) juju models;;
3 ) juju machines;;
4 )
#Wait Times
#wait1="sleep 30m"
wait1="echo 'Next>Press Enter Key'&&read"

# Debug
#juju debug-log --replay --level WARNING 2>&1|tee -a openstack-deperr.out &

#Juju 1.25まで
#juju deploy mysql --to lxc:25
#Juju 2.0以降
#juju deploy mysql --to lxd:25

# Deploy the OpenStack Charms
juju deploy --config openstack.yaml cs:xenial/nova-compute --to 2
eval ${wait1}

juju deploy cs:xenial/rabbitmq-server --to lxd:0 &&
juju add-unit rabbitmq-server --to lxd:1
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/nova-cloud-controller --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:trusty/mysql --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/glance --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/keystone --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/openstack-dashboard --to lxd:0
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/neutron-openvswitch
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/neutron-api  --to lxd:1
eval ${wait1}

juju deploy --config openstack.yaml cs:xenial/neutron-gateway --to 1
eval ${wait1}

echo "EOF"
;;
* ) echo "Set the 1 - 4. 1:View Status/2:View Models/3:View Machines/4:Deploy the OpenStack";;
esac
