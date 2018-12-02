1.Transfer the “playbook.zip” onto a VCL machine.

2.On a VCL machine, install ansible using the commands:
"sudo apt-add-repository ppa:ansible/ansible"
"sudo apt-get update"
"sudo apt-get install ansible"

3. Move the “playbook.zip” in the root directory using the command:
“sudo mv playbook.zip/ /root/“

4.Type sudo su - on the VCL

5. Unzip the file using the command:
 "unzip playbook.zip"

6. Type cd playbook-hw

//7. Type vim var.yml
Here you will need to change the parameters:
subnet_num == The number of subnets to be connected, for example : 2
subnet_range == The range of the subnets,
  for example : 152.10.1.1/24, 152.11.1.1/24
container_numbers == Number of containers in each subnet [ for example CS1 and CS2 are in subnet 1, so container number will be 2 ]
//---------DON'T DO THE 7TH STEP--------------------------------------------------------//
8. After making the changes, type :
“ansible-playbook main.yml”

9.Type "docker ps" to check the created dockers
//--------YOU CAN SEE THE CREATED DOCKERS AFTER THE 9TH STEP-------------------------//

((((DONT DO ANYTHING ONCE THE DOCKERS ARE CREATED))))


10.Type docker exec -it <docker_name> bash  ; EX: CS11

11.Ping from CS11<ip> to CS21<ip> to check connectivity

12.In order to check gre tunnel , type "ip tunnel" command on the SC<> containers
