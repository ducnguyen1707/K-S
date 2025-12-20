# **Create EKS Management EC2**

### Create a EC2

Install  **Kubectl**

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

********or 

chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH

kubectl version --client # for checking
```

Install **AWS CLI**

```
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

Install **EKSCTL**

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

# Create **IAM and attach to EKS Manager**

Create Role → AWS service → Usecase: EC2 → Permission: [**AdministratorAccess](https://us-east-1.console.aws.amazon.com/iam/home?region=ap-southeast-1#/policies/details/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2FAdministratorAccess)** 

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
```

Attach IAM to EC2 throught Action → Sercurity → Modify IAM

### Create EKSCTL to create  cluster on EKS

eksctl create cluster --name ducnguyen-EKS-cluster2 --region ap-south-1 --node-type t2.medium  --zones ap-south-1a,ap-south-1

# Set up for  worker node

### Generate ssh-key

```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/eks-worker -N "”
cat ~/.ssh/eks-worker.pub
```

### Import key on AWS

```bash
aws ec2 import-key-pair \
--key-name eks-worker \
--public-key-material fileb://~/.ssh/eks-worker.pub \
--region ap-south-1

aws ec2 describe-key-pairs --key-names eks-worker --region ap-south-1
#for check
```

### Create Clusterconfig
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ducnguyen-EKS-cluster2
  region: ap-south-1

managedNodeGroups:
  - name: worker-hotel-nginx-1
    instanceType: t2.medium
    desiredCapacity: 2
    minSize: 1
    maxSize: 2
    volumeSize: 25
    ssh:
      allow: true
      publicKeyName: eks-worker

eksctl create nodegroup -f ~/create_node/create-worker.yml


