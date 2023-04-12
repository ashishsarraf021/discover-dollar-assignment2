# discover-dollar-assignment2


1.Set up your AWS credentials by creating a new AWS Access Key ID and Secret Access Key.

2.Install Terraform on your local machine. You can follow the instructions on the Terraform website: https://www.terraform.io/downloads.html

3.Clone the GitHub repository to your local machine. git clone

4.cd discover-dollar-assignment1/main.tf

** Open the variables.tf file and update the following variables:
1.aws_region: The AWS region where you want to deploy the infrastructure.
2.aws_subnet_cidr_public: The CIDR block for the public subnet.
3.aws_subnet_cidr_private: The CIDR block for the private subnet.
4.aws_key_name: The name of the SSH key pair you want to use to access the virtual machine.

follow the steps for creating infrastruture on your instance :

i. aws configure 
ii. fill the acess key and secret access key of your AWS IAM user. 
iii.terraform init 
iv. terraform plan 
v. terraform apply

#Once the infrastructure is created, you can SSH into the virtual machine by running the following command:

ssh -i ubuntu@ (change according to your instance)

#To check the public IP address of the virtual machine, run the following command:

curl ifconfig.me

When you are finished with the infrastructure, run "terraform destroy" to delete it.
