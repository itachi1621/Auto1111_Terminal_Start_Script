#!/bin/bash
# This script is used to spawn tabs that will be used for auto1111 on EC2 instances im using ubuntu 20.04 on a g4dn.xlarge instance
#ubuntu is the default user for the AMI i am using so you may need to change that if you are using a different AMI
# This script is meant to be run on the local machine

# Function to prompt for IP address if not provided as an argument
ssh_user=ubuntu
remote_a1111_port=7860
local_a1111_port=7860
StrictHostKeyCheckValue=no #This is to avoid the prompt to add the host to the known hosts file i know its not the best practice but elastic ips are not free anymore
#you can change it to ask or yes if you want to be prompted to add the host to the known hosts file

getIp() {
    if [ -z "$ip" ]; then
        read -p "Enter the IP of the EC2 machine: " ip
        if [ -z "$ip" ]; then
            echo "No IP entered"
            getIp
        fi
    fi
}

# Function to prompt for identity file path if not provided as an argument
getIdentityFilePath() {
    if [ -z "$identityFilePath" ]; then
        read -p "Enter the path to the identity file: " identityFilePath
        if [ -z "$identityFilePath" ]; then
            echo "No identity file path entered"
            getIdentityFilePath
        fi
    fi
}

# Function to spawn tabs
spawnTabs(){
# Setup port forwarding for the auto1111 default port
gnome-terminal --tab --title="Auto 1111 port forward" -- bash -c "ssh -N -L $remote_a1111_port:127.0.0.1:$local_a1111_port -o StrictHostKeyChecking=$StrictHostKeyCheckValue $ssh_user@$ip -i $identityFilePath; read -p 'Press Enter to close this window...'"

# Open the terminal that will be used to run the auto1111.sh script
#gnome-terminal --tab --title="Auto 1111" -- bash -c "ssh $ssh_user@$ip -t -o StrictHostKeyChecking=$StrictHostKeyCheckValue -i $identityFilePath 'cd auto1111/ && ./preload.sh; read -p \"Press Enter to close this window...\"'"

# Open the terminal for monitoring resource usage with htop
gnome-terminal --tab --title="Resource Monitor" -- bash -c "ssh $ssh_user@$ip -t -o StrictHostKeyChecking=$StrictHostKeyCheckValue -i $identityFilePath ' htop; read -p \"Press Enter to close this window...\"'" # -t is used to force a pseudo-terminal allocation so that htop can run automatically makeswap uses the ephemeral storage as swap space

# Open the remote shell terminal
gnome-terminal --tab --title="Remote Shell" -- bash -c "ssh $ssh_user@$ip -t -o StrictHostKeyChecking=$StrictHostKeyCheckValue -i $identityFilePath; read -p 'Press Enter to close this window...'"
}

# Check for arguments
while getopts "i:p:" opt; do
    case $opt in
        i) identityFilePath="$OPTARG";; #You can use -i to specify the identity file path, e.g. -i /path/to/identity/file.pem otherwise youl'll get proomted
        p) ip="$OPTARG";; #You can use -p to specify the IP address of the EC2 instance, e.g. -p  54.86.79.10 and yes i know p is weird for ip
        \?) echo "Invalid option: -$OPTARG" >&2;;
    esac
done

# Prompt for missing arguments
getIp
getIdentityFilePath


# Call the function to spawn tabs
spawnTabs

