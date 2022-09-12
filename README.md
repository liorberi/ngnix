
# Architecture:


1. Ec2 with Nginx (deployed by ngninx.sh script)
2. ASG for the EC2 with a 2 instances. 
3. Application Load Balancer with the ec2 as listeners.
Public IPs are prohibited, and all the components or services are
required to be exposed privately. Make sure to allocate it only where
it’s necessary.
Assumptions and conditions:
1. All resources can access the internet without any restrictions
(egress traffic only).
2. The implementation ismade by Terraform 


#############################################
## terraform will configure ## :

# creating VPC 
# Create a public subnet for the VPC we created above
# Create an Internet Gateway for the VPC. The VPC require an IGW to communicate over the internet.
# Create a custom route table for the VPC.
# Associate the route table with the public subnet.
# Create a security group to allow SSH access and HTTP access.
# Add the following code block in the main.tf file to associate an SSH public key with the AWS EC2 instance.
# Setting up the ssh connection to install the nginx server
# Create Load balancer listener 


==============================================================


# installation:

Install Terraform on Ubuntu 22.04:


Before we can install Terraform, make sure your system is up to date, you have GnuPG, software-properties-common, and curl packages installed.

1. Run system updates
Begin by updating your system repositories to make them up to date. Use the following command to run system updates.

sudo apt update && apt upgrade -y 
2. Install Terraform Package dependencies
Install the following dependencies, software-properties-common, GnuPG, and curl on your system using the following command.

sudo apt install -y gnupg software-properties-common curl
It will not install any packages because Ubuntu 22.04 comes preinstalled with the following packages. So what you can do is just update them.

3. Add Hashicorp GPG key
Next in line is to add the Hashicorp GPG key into our system. We are going to install using the curl command we installed earlier.

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
4. Add Hashicorp repository to Ubuntu 22.04
Now we need to tell our system where to get installation packages from and that is by adding the Hashicorp repository to our system repositories. To add repositories, we need to use the following command.

sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Check what has been added to your system. See below output

Output
Repository: 'deb [arch=amd64] https://apt.releases.hashicorp.com jammy main'
Description:
Archive for codename: jammy components: main
More info: https://apt.releases.hashicorp.com
Adding repository.
Press [ENTER] to continue or Ctrl-c to cancel.
Adding deb entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-jammy.list
Adding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-jammy.list
Get:1 http://mirrors.digitalocean.com/ubuntu jammy InRelease [270 kB]
Hit:2 http://mirrors.digitalocean.com/ubuntu jammy-updates InRelease                                                                        
Get:3 https://apt.releases.hashicorp.com jammy InRelease [10.3 kB]                                                                          
Hit:4 http://mirrors.digitalocean.com/ubuntu jammy-backports InRelease                                                                      
Hit:5 https://repos-droplet.digitalocean.com/apt/droplet-agent main InRelease                    
Hit:6 http://security.ubuntu.com/ubuntu jammy-security InRelease           
Get:7 https://apt.releases.hashicorp.com jammy/main amd64 Packages [57.7 kB]
Fetched 338 kB in 7s (48.3 kB/s)
Reading package lists... Done
Lastly is to update our system repositories again for changes to take effect.

$ sudo apt update 
5. Install Terraform on Ubuntu 22.04
After we have met all the requirements, we can now run terraform installation with ease. Run the following command on your terminal.

$ sudo apt install terraform
The sample output will be like this;

Output
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 19.9 MB of archives.
After this operation, 62.9 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com jammy/main amd64 terraform amd64 1.2.3 [19.9 MB]
Fetched 19.9 MB in 0s (91.7 MB/s)
Selecting previously unselected package terraform.
(Reading database ... 93711 files and directories currently installed.)
Preparing to unpack .../terraform_1.2.3_amd64.deb ...
Unpacking terraform (1.2.3) ...
Setting up terraform (1.2.3) ...
Scanning processes...                                                                                                                        
Scanning candidates...                                                                                                                       
Scanning linux images...  
Now that we have installed Terraform, we can verify the installation with the following command;

$ terraform -help init

Usage: terraform [global options] init [options]

  Initialize a new or existing Terraform working directory by creating
  initial files, loading any remote state, downloading modules, etc.

  This is the first command that should be run for any new or existing
  Terraform configuration per machine. This sets up all the local data
  necessary to run Terraform that is typically not committed to version
  control.

  This command is always safe to run multiple times. Though subsequent runs
  may give errors, this command will never delete your configuration or
  state. Even so, if you have important information, please back it up prior
  to running this command, just in case.
Check the version of installed Terraform with terraform -v command.

terraform -v 
Terraform v1.2.3
Let’s install a package using Terraform to see if it’s actually working.

First, enable tab autocompletion

$ touch ~/.bashrc
Then install the auto-completion package with the following command;

$ terraform -install-autocomplete
Restart your shell for changes to take effect.

Installing Terraform using the downloaded zip file
Another hustle-free way to install Terraform is to download the zip file and extract it to your preferred location. Let’s see how we can do that.

Go to Terraform download section and hit download amd64 to download a zip file.
To unzip the file install unzip using the following command apt install unzip.
To unzip the file use unzip terraform_1.2.3_linux_amd64.zip
Move the unzipped file to /usr/local/bin directory using this command mv terraform /usr/local/bin
Terraform is now installed, you can check the version with terraform -v command.
To initialize a project in Terraform we use, terraform init command

terraform init
To provision a container, use terraform apply command

terraform apply
To stop a container use terraform destroy command

=====================================================

Step 2 : 

connect ubuntu machine to AWS

===================================================

step 3:

clone this repo to your machine and run terraform

===========================================







