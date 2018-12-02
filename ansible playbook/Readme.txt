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

7. After changing the directory, type :
“ansible-playbook main.yml”

8.Type "docker ps" to check the created dockers
