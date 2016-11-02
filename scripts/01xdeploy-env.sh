#!/bin/bash

#For Xenial & Juju 2.0/Update:2016/11/02
if [ -e /usr/bin/juju ]; then
    # 存在する場合
    echo "File exists:Juju-Core is Installed."
else
    # 存在しない場合
    sudo add-apt-repository -y ppa:juju/stable && sudo apt update && sudo apt install -y juju &&
    echo "See This Docs. https://jujucharms.com/docs/stable/getting-started" && exit
fi

case $1 in
1 )
juju status --format tabular;;

2 )
echo "Add the bootstrap Machine."
juju bootstrap --constraints tags=kvm1 maas maas --show-log 2>&1 | tee bootstrap-err.out;;

3 )
echo "Add the Machines."
#debug
#juju debug-log --replay --level WARNING 2>&1 |tee -a deploy-err.out &
juju add-model openstack && juju switch openstack &&
juju add-machine --constraints tags=physical1
juju add-machine --constraints tags=physical2
juju add-machine --constraints tags=physical3
juju gui
;;

4 )
juju destroy-model openstack
echo "And Run this command> juju models && juju machines"
echo "If Juju Macine exsist in openstack Modeles. Run this command> juju remove-machine <num> --force."
;;

* ) echo "Set the 1 - 4. 1:View Status/2:Bootstrap/3:Deploy/4:Remove Env.";;
esac