# AWS EC2 Auto1111 Terminal Startup Script

## Introduction
This script is designed to spawn tabs that facilitate managing auto1111 on EC2 instances. It's was configured for Ubuntu 20.04 on a `g4dn.xlarge` instance but should work on other instance types used for auto1111, i.e.. g4ad.xxxx The default user for the Amazon Machine Image (AMI) used is `ubuntu`. If you're using a different AMI, you may need to change the default user.

## Prerequisites
- Ubuntu 20.04 or greater on a `g4dn.xlarge` instance or `2xlarge` etc.
- Knowledge of the IPV4 address of the EC2 machine e.g 123.456.789.10
- An identity file (SSH key) for authentication which is typically reccommended when creating EC2 instances.

## Usage
### Command Line Arguments
The script supports the following command-line arguments:
- `-i`: Specify the path to the identity file (e.g., `-i /path/to/identity/file.pem`). If not provided, you'll be prompted to enter it.
- `-p`: Specify the IP address of the EC2 instance (e.g., `-p 54.86.79.10`). If not provided, you'll be prompted to enter it.

### Running the Script
1. Clone the repository.
2. Navigate to the directory containing the script.
3. Ensure the script is executable with `chmod +x auto1111_term_start.sh` or via the gui in your os.
4. Run the script using `./auto1111_term.start.sh` or  `./auto1111_term.start.sh -i identity_file -p ip_address` .

## Behavior
- The script will prompt you for the IP address of the EC2 instance if not provided as a command-line argument.
- It will also prompt for the path to the identity file if not provided.
- Upon execution, the script will spawn several tabs in `gnome-terminal`, each serving a specific purpose:
  - **Auto 1111 Port Forward**: Sets up port forwarding for the auto1111 default port which is `*7890* to *localhost:7890*`.
  - **Resource Monitor**: Opens a terminal for monitoring resource usage with `htop`.
  - **Remote Shell**: Opens a terminal for remote shell access to the EC2 instance.

## Notes
- The script uses `-o StrictHostKeyChecking=no` in the ssh command to avoid the prompt to add the host to the known hosts file. This is not typically recommended for production environments but can be useful for convenience in cases where you don't have a static ip or dont wish to pay for one as is the case with AWS Elastic IP's as of February 2024.
- Ensure that you have the necessary permissions and configurations set up on your EC2 instance for SSH access.
