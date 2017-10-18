#!/bin/bash


#For Xenial & Juju 2.2.4/Update:2017/10/16
#wait2="sleep 5m"
wait2="echo 'Next>Press Enter Key'&&read"

#Debug
#juju debug-log --replay --level WARNING 2>&1|tee -a relation-err.out &

#To MySQL
echo "add-relation22> keystone:mysql"
juju add-relation keystone percona-cluster
eval ${wait2}

echo "add-relation21> glance:mysql"
juju add-relation glance percona-cluster
eval ${wait2}

echo "add-relation20> nova-cloud-controller:mysql"
juju add-relation nova-cloud-controller percona-cluster
eval ${wait2}

echo "add-relation19> neutron-api:mysql"
juju add-relation neutron-api percona-cluster
eval ${wait2}

#To Rabbit
echo "add-relation18> neutron-api:rabbitmq-server"
juju add-relation neutron-api rabbitmq-server
eval ${wait2}

echo "add-relation17> neutron-gateway:amqp:rabbitmq-server:amqp"
juju add-relation neutron-gateway:amqp rabbitmq-server:amqp
eval ${wait2}

echo "add-relation16> neutron-gateway:amqp-nova:rabbitmq-server:amqp"
juju add-relation neutron-gateway:amqp-nova rabbitmq-server:amqp
eval ${wait2}

echo "add-relation15> neutron-openvswitch:rabbitmq-server"
juju add-relation neutron-openvswitch rabbitmq-server
eval ${wait2}

echo "add-relation14> nova-cloud-controller:rabbitmq-server"
juju add-relation nova-cloud-controller rabbitmq-server
eval ${wait2}

echo "add-relation13> nova-compute:amqp:rabbitmq-server:amqp"
juju add-relation nova-compute-lxd:amqp rabbitmq-server:amqp
eval ${wait2}


#To Keystone
echo "add-relation12> glance:keystone"
juju add-relation glance keystone
eval ${wait2}

echo "add-relation11> neutron-api:keystone"
juju add-relation neutron-api keystone
eval ${wait2}

echo "add-relation10> nova-cloud-controller:keystone"
juju add-relation nova-cloud-controller keystone
eval ${wait2}

echo "add-relation9> openstack-dashboard:keystone"
juju add-relation openstack-dashboard keystone
eval ${wait2}


#From Nova
echo "add-relation8> nova-cloud-controller:glance"
juju add-relation nova-cloud-controller glance
eval ${wait2}

echo "add-relation7> nova-cloud-controller:nova-compute"
juju add-relation nova-cloud-controller nova-compute-lxd
eval ${wait2}

echo "add-relation6> nova-compute:glance"
juju add-relation nova-compute-lxd glance
eval ${wait2}


#From Neutron
echo "add-relation5> neutron-api:nova-cloud-controller"
juju add-relation neutron-api nova-cloud-controller
eval ${wait2}

echo "add-relation4> neutron-api:neutron-gateway"
juju add-relation neutron-api neutron-gateway
eval ${wait2}

echo "add-relation3> neutron-api:neutron-openvswitch"
juju add-relation neutron-api neutron-openvswitch
eval ${wait2}

echo "add-relation2> neutron-openvswitch:nova-compute"
juju add-relation neutron-openvswitch nova-compute-lxd
eval ${wait2}

echo "add-relation1> neutron-gateway:nova-cloud-controller"
juju add-relation neutron-gateway nova-cloud-controller
eval ${wait2}


echo "Finished!"
