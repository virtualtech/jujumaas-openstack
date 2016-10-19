#!/bin/bash


#For Xenial & Juju 2.0/Update:2016/10/11
#Wait Times
#wait2="sleep 30m"
wait2="echo 'Next>Press Enter Key'&&read"

#Debug
#juju debug-log --replay --level WARNING 2>&1|tee -a relation-err.out &

#To MySQL
echo "add-relation> keystone:mysql"
juju add-relation keystone mysql
eval ${wait2}

echo "add-relation> glance:mysql"
juju add-relation glance mysql
eval ${wait2}

echo "add-relation> nova-cloud-controller:mysql"
juju add-relation nova-cloud-controller mysql
eval ${wait2}

echo "add-relation> neutron-api:mysql"
juju add-relation neutron-api mysql
eval ${wait2}

#To Rabbit
echo "add-relation> neutron-api:rabbitmq-server"
juju add-relation neutron-api rabbitmq-server
eval ${wait2}

echo "add-relation> neutron-gateway:amqp:rabbitmq-server:amqp"
juju add-relation neutron-gateway:amqp rabbitmq-server:amqp
eval ${wait2}

echo "add-relation> neutron-gateway:amqp-nova:rabbitmq-server:amqp"
juju add-relation neutron-gateway:amqp-nova rabbitmq-server:amqp
eval ${wait2}

echo "add-relation> neutron-openvswitch:rabbitmq-server"
juju add-relation neutron-openvswitch rabbitmq-server
eval ${wait2}

echo "add-relation> nova-cloud-controller:rabbitmq-server"
juju add-relation nova-cloud-controller rabbitmq-server
eval ${wait2}

echo "add-relation> nova-compute:amqp:rabbitmq-server:amqp"
juju add-relation nova-compute:amqp rabbitmq-server:amqp
eval ${wait2}


#To Keystone
echo "add-relation> glance:keystone"
juju add-relation glance keystone
eval ${wait2}

echo "add-relation> neutron-api:keystone"
juju add-relation neutron-api keystone
eval ${wait2}

echo "add-relation> nova-cloud-controller:keystone"
juju add-relation nova-cloud-controller keystone
eval ${wait2}

echo "add-relation> openstack-dashboard:keystone"
juju add-relation openstack-dashboard keystone
eval ${wait2}


#From Nova
echo "add-relation> nova-cloud-controller:glance"
juju add-relation nova-cloud-controller glance
eval ${wait2}

echo "add-relation> nova-cloud-controller:nova-compute"
juju add-relation nova-cloud-controller nova-compute
eval ${wait2}

echo "add-relation> nova-compute:glance"
juju add-relation nova-compute glance
eval ${wait2}


#From Neutron
echo "add-relation> neutron-api:nova-cloud-controller"
juju add-relation neutron-api nova-cloud-controller
eval ${wait2}

echo "add-relation> neutron-api:neutron-gateway"
juju add-relation neutron-api neutron-gateway
eval ${wait2}

echo "add-relation> neutron-api:neutron-openvswitch"
juju add-relation neutron-api neutron-openvswitch
eval ${wait2}

echo "add-relation> neutron-openvswitch:nova-compute"
juju add-relation neutron-openvswitch nova-compute
eval ${wait2}

echo "add-relation> neutron-gateway:nova-cloud-controller"
juju add-relation neutron-gateway nova-cloud-controller
eval ${wait2}


#MySQL-HA
wait3="echo 'Quetion> Need MySQL-Ha? Press 'Y' Key.' && read que1"
runcommand="juju deploy mysql mysql-slave --to lxd:1 && juju add-relation mysql:master mysql-slave:slave"

eval ${wait3}
if [ "$que1" = "Y" -o "$que1" = "y" ];
then
eval ${runcommand}
else
echo "Skiped."
fi

echo "Finished!"