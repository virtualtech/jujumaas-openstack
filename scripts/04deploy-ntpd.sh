#!/bin/bash

#Checked: Xenial & Juju 2.2.4/Update:2017/9/20
#Checked: Xenial & Juju 2.0.2/Update:2017/9/15

#Wait Times
wait1="echo 'Next>Press Enter Key'&&read"
wait2="sleep 10s"

#Deploy the NTPD
juju deploy ntpmaster --to lxd:1
eval ${wait1}
juju deploy ntp && juju add-relation ntp ntpmaster
eval ${wait1}

#Relation the OpenStack Nodes
ARRAY=(keystone glance neutron-api neutron-gateway neutron-openvswitch nova-cloud-controller nova-compute openstack-dashboard rabbitmq-server)

for item in ${ARRAY[@]}; do
juju add-relation ntp $item && eval ${wait2}
done

echo "Finished!"
