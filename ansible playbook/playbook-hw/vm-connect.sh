#!/bin/bash
array=( $@ )
len=${#array[@]}
subnet_num=${array[0]}
IFS=', ' read -r -a subnet_range <<< ${array[1]}
IFS=', ' read -r -a vm_num <<< ${array[2]}


for (( i=1; i<=${subnet_num}; i++))
do
    srange=${subnet_range[i-1]}
    ipigw=`echo ${srange//.0\//.1/}`
    igw=${ipigw::-3}    
    for (( j=1; j<=${vm_num[i-1]}; j++))
    do
        count=$[j+1]
        ip=`echo ${srange//.0\//.$count/}`
	
		docker run --name CS${i}${j} -td pmalik3311/team1ubuntu
		ip link add vethVB${i}${j} type veth peer name vethBV${i}${j}
		pid=`docker inspect -f {{.State.Pid}} CS${i}${j}`
		if [ ! -L /var/run/netns/CS${i}${j} ]; then
		#echo "aaaaaa"
   			ln -s /proc/${pid}/ns/net /var/run/netns/CS${i}${j}
		fi
		ip link set vethVB${i}${j} netns ${pid}
		echo ${ip}
		ip netns exec CS${i}${j} ip addr add ${ip} dev vethVB${i}${j}
		ip netns exec CS${i}${j} ip link set vethVB${i}${j} up
		ip netns exec CS${i}${j} ip route del default
		ip netns exec CS${i}${j} ip route add default via ${igw}
		ip link set vethBV${i}${j} up
		
		brctl addif LC${i}BR${i} vethBV${i}${j}		
		
	done
	ip link add vethIB${i} type veth peer name vethBI${i}
	pid=`docker inspect -f {{.State.Pid}} LC${i}`
	if [ ! -L /var/run/netns/LC${i} ]; then
   		ln -s /proc/${pid}/ns/net /var/run/netns/LC${i}
	fi
	ip link set vethIB${i} netns ${pid}
	ip netns exec LC${i} ip addr add ${ipigw} dev vethIB${i}
	ip netns exec LC${i} ip link set vethIB${i} up
	ip link set vethBI${i} up
	
	brctl addif LC${i}BR${i} vethBI${i}		
	ip link set LC${i}BR${i} up
	
	echo -e "  network ${srange}" >> /root/playbook_logs/bgpFiles/bgpdLC${i}.conf
	#docker cp /root/playbook_logs/bgpFiles/bgpd${vpc_name}IGW${i}.conf ${vpc_name}IGW${i}:/etc/quagga/bgpd.conf
	#docker exec ${vpc_name}IGW${i} chown quagga:quagga /etc/quagga/bgpd.conf
	#docker exec ${vpc_name}IGW${i} /usr/lib/quagga/quagga restart
done


