# README

## Introduction

## Pre-requisites

### Command line

#### AWS CLI

* Need AWS CLI tool configured correctly
* region (recommended: us-west-2 or us-east-2)
* access key
* secret access key 

#### Permissions 

These are broad permissions — you likely don’t need all this. Remove once done.

* AmazonEC2ContainerRegistryFullAccess
* AmazonEC2FullAccess
* AmazonRDSFullAccess


## Steps to deploy

### Application

Login to ECR. (no output because of $())

```
$(aws ecr get-login --no-include-email --region [YOUR_AWS_REGION])
```

Build the docker image for the unicorn-ads/backend docker repo.

```
docker build -t unicorn-ads/backend .
```

Push this image to the docker repository.

```
docker push [INSERT_AWS_ACCOUNT_NUMBER].dkr.ecr.us-west-2.amazonaws.com/unicorn-ads/backend:latest
```

TODO Add further steps to deploy to Fargate...

### Database

Get default VPC id.

```
aws ec2 describe-vpcs | jq '.Vpcs[] | select(.IsDefault).VpcId'
```

Get default VPC’s subnet ids: (use vpc-id from above as parameter to filter!).

```
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=[INSERT_VPC_ID]" | jq '.Subnets[].SubnetId'
```

Create DB Subnet Group with above subnet ids.

```
aws rds create-db-subnet-group \
  --db-subnet-group-name unicorn-ads-subnet-group \
  --db-subnet-group-description "Unicorn Ads Subnet Group" \
  --subnet-ids "[INSERT_SUBNET_ID_1]" "[INSERT_SUBNET_ID_2]" "[INSERT_SUBNET_ID_3]"
```

Create a new DB cluster parameter group. We'll use this to eventually enable binlogs from the master cluster.

We're creating this a bit ahead of time so that it's ready by the time we create a cluster and its instances. 

```
aws rds create-db-cluster-parameter-group \
  --db-cluster-parameter-group-name unicorn-ads-db-cluster-parameter-group \
  --db-parameter-group-family aurora5.6 \
  --description 'Custom cluster parameter group for Unicorn Ads cluster' 
```

Now modify the above cluster parameter group to enable binlog by setting ```binlog_format=MIXED```
```
aws rds modify-db-cluster-parameter-group \
  --db-cluster-parameter-group-name unicorn-ads-db-cluster-parameter-group \
  --parameters 'ParameterName=binlog_format,ParameterValue=MIXED,ApplyMethod=pending-reboot'
```

Create a database security group to add DB ingress rules (use the value of vpc-id from above for the --vpc-id option).

```
aws ec2 create-security-group \
  --group-name db-security-group \
  --description 'Database security group' \
  --vpc-id [INSERT_VPC_ID]
``` 



Configure the security group to allow ingress traffic to port 3306. Use the security group id from the above step as parameter to ```--group-id``` below.

**N.B.** We're only opening up this port for the purposes of this session. Typically, you would want to lock your database network rules (security group) down so that it is only accessible by your web application or app backend and not from anywhere. 

```
aws ec2 authorize-security-group-ingress \
  --group-id [INSERT_SECURITY_GROUP_ID] \
  --protocol tcp \
  --port 3306 \
  --cidr 0.0.0.0/0
``` 

Create the Aurora database cluster (MySQL 5.6).

```
aws rds create-db-cluster \
  --db-cluster-identifier unicorn-ads \
  --engine aurora --master-username ads \
  --master-user-password [INSERT_DB_PASSWORD!] \
  --db-subnet-group-name unicorn-ads-subnet-group  \
  --db-cluster-parameter-group-name unicorn-ads-db-cluster-parameter-group
  --vpc-security-group-ids [INSERT_SECURITY_GROUP_ID]
```

Create the first Aurora database instance associated with above cluster (MySQL 5.6).

```
aws rds create-db-instance \
  --db-instance-identifier unicorn-ads-instance \
  --db-cluster-identifier unicorn-ads \
  --engine aurora \
  --db-instance-class db.t2.medium \
  --publicly-accessible
```

Create another Aurora database instance and associate it with the same cluster for HA and read-scaling. (also MySQL 5.6).

```
aws rds create-db-instance \
  --db-instance-identifier unicorn-ads-instance-replica \
  --db-cluster-identifier unicorn-ads \
  --engine aurora \
  --db-instance-class db.t2.medium \
  --publicly-accessible
```

#### Cross Region Read Replica Database

All commands below add a ```--region [FAILOVER_REGION]``` parameter since we're creating a database replica and associated VPCs, subnets etc. in another region.

Get default VPC id.  

```
aws ec2 describe-vpcs \
  --region [INSERT_FAILOVER_REGION] | jq '.Vpcs[] | select(.IsDefault).VpcId'
```

Get default VPC’s subnet ids: (use vpc-id from above as parameter to filter!)

```
aws ec2 describe-subnets \
  --region [INSERT_FAILOVER_REGION] \
  --filters "Name=vpc-id,Values=[INSERT_VPC_ID]" | jq '.Subnets[].SubnetId'
```

Create DB Subnet Group with above subnet ids.

```
aws rds create-db-subnet-group \
  --region [INSERT_FAILOVER_REGION] \
  --db-subnet-group-name unicorn-ads-subnet-group \
  --db-subnet-group-description "Unicorn Ads Subnet Group" \
  --subnet-ids "[INSERT_SUBNET_ID_1]" "[INSERT_SUBNET_ID_2]" "[INSERT_SUBNET_ID_3]"
```

Create a database security group to add DB ingress rules (use the value of vpc-id from above for the --vpc-id option).

```
aws ec2 create-security-group \
  --region [INSERT_FAILOVER_REGION] \
  --group-name db-security-group \
  --description 'Database security group' \
  --vpc-id [INSERT_VPC_ID]
``` 

Configure the security group to allow ingress traffic to port 3306. Use the security group id from the above step as parameter to the ```--group-id``` option below.

**N.B.** We made a mention of this previously, but mentioning it again. We're only opening up this port for the purposes of this session. Typically, you would want to lock your database network rules (security group) down so that it is only accessible by your web application or app backend and not from anywhere. 

```
aws ec2 authorize-security-group-ingress \
  --region [INSERT_FAILOVER_REGION] \
  --group-id [INSERT_SECURITY_GROUP_ID] \
  --protocol tcp \
  --port 3306 \
  --cidr 0.0.0.0/0
``` 

OPTIONAL: We'll need to pass the original DB cluster's ARN to the ```--replication-source-identifier``` parameter option below. You can either copy this value from when you created it originally, or run the command below to get it post-facto.

```
aws rds describe-db-clusters \
  --region [INSERT_FAILOVER_REGION] \
  --db-cluster-identifier unicorn-ads | jq '.DBClusters[].DBClusterArn'
```

Create the Aurora read-replica database cluster (MySQL 5.6). Use the same security group id as parameter to the ```--vpc-security-group-ids``` option and the cluster ARN value from above as parameter to ```--replication-source-identifier```.

```
aws rds create-db-cluster \
  --region [INSERT_FAILOVER_REGION] 
  --db-cluster-identifier unicorn-ads-replica-cluster \
  --replication-source-identifier [INSERT_ORIGINAL_DB_CLUSTER_ARN] \
  --engine aurora \
  --master-username ads \
  --master-user-password Hacker355! \
  --db-subnet-group-name unicorn-ads-subnet-group \
  --vpc-security-group-ids [INSERT_SECURITY_GROUP_ID] 
```

Create the first Aurora database instance associated with above read-replica cluster (MySQL 5.6).

```
aws rds create-db-instance \
  --region [INSERT_FAILOVER_REGION] \ 
  --db-instance-identifier unicorn-ads-instance \
  --db-cluster-identifier unicorn-ads-read-replica-cluster \
  --engine aurora \
  --db-instance-class db.t2.medium \
  --publicly-accessible
```

Create another Aurora database instance and associate it with the same read-replica cluster for HA and read-scaling. (also MySQL 5.6).

```
aws rds create-db-instance \
  --region [INSERT_FAILOVER_REGION] \
  --db-instance-identifier unicorn-ads-instance-replica \
  --db-cluster-identifier unicorn-ads-read-replica-cluster \
  --engine aurora \
  --db-instance-class db.t2.medium \
  --publicly-accessible
```

