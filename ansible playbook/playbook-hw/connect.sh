#!/bin/bash
subnet_num=${1}
echo ${subnet_num}
#touch f1
for (( j=1; j<=${subnet_num}; j++))
do
echo -e "router bgp ${j} " >>  /root/playbook_logs/bgpFiles/bgpdLC${j}.conf
done
for (( i=1; i<=2; i++ ))
do
        for (( j=1 ; j<=${subnet_num} ; j++ ))
        do

        ip link add vethE${i}I${j} type veth peer name vethI${i}E${j}
        pid=`docker inspect -f {{.State.Pid}} SC${i}`
        ip link set vethE${i}I${j} netns ${pid}

        pid=`docker inspect -f {{.State.Pid}} LC${j}`
        if [ ! -L /var/run/netns/LC${j} ]; then
                #echo "aaaaaa"
                ln -s /proc/${pid}/ns/net /var/run/netns/LC${j}
        fi
        ip link set vethI${i}E${j} netns ${pid}
        ip netns exec SC${i} ip addr add  ${i}${j}.0.0.1/24 dev vethE${i}I${j}
    	ip netns exec LC${j} ip addr add ${i}${j}.0.0.2/24 dev vethI${i}E${j}
        ip netns exec SC${i} ip link set  vethE${i}I${j} up
        ip netns exec LC${j} ip link set  vethI${i}E${j} up
        echo -e "  neighbor ${i}${j}.0.0.2 remote-as ${j} \n  network ${i}${j}.0.0.0/24" >> /root/playbook_logs/bgpFiles/bgpdSC${i}.conf
        echo -e "  neighbor ${i}${j}.0.0.1 remote-as 10${i} \n  network ${i}${j}.0.0.0/24" >> /root/playbook_logs/bgpFiles/bgpdLC${j}.conf
        
        done

   	#docker cp /root/bgpFiles/bgpd${vpc_name}EGW${i}.conf ${vpc_name}EGW${i}:/etc/quagga/bgpd.conf
   	#docker exec ${vpc_name}EGW${i} chown quagga:quagga /etc/quagga/bgpd.conf 
	#docker exec ${vpc_name}EGW${i} /usr/lib/quagga/quagga restart
        
done
                

