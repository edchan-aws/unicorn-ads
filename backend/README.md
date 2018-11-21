# README

## Introduction

## Pre-requisites

## Steps to deploy

#### Application

#### Databsse

Get default VPC id:

```
aws ec2 describe-vpcs | jq '.Vpcs[] | select(.IsDefault).VpcId'
```

Get default VPC’s subnet ids: (use vpc-id from above as parameter to filter!)

```
aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-99999999" | jq '.Subnets[].SubnetId'
```

Create DB Subnet Group with above subnet ids

```
aws rds create-db-subnet-group --db-subnet-group-name unicorn-ads-subnet-group --db-subnet-group-description "Unicorn Ads Subnet Group" --subnet-ids "subnet-953a19df" "subnet-a524c6cc" "subnet-956464ed"
```

Create the Aurora database cluster (MySQL 5.6)

```
aws rds create-db-cluster --db-cluster-identifier unicorn-ads --engine aurora --master-username ads --master-user-password PASSWORD! --db-subnet-group-name unicorn-ads-subnet-group
```

Create the first Aurora database instance associated with above cluster (MySQL 5.6)

```
aws rds create-db-instance --db-instance-identifier unicorn-ads-instance --db-cluster-identifier unicorn-ads --engine aurora --db-instance-class db.t2.medium
```

Create another Aurora database instance and associate it with the same cluster for HA and read-scaling. (also MySQL 5.6)

```
aws rds create-db-instance --db-instance-identifier unicorn-ads-instance-replica --db-cluster-identifier unicorn-ads --engine aurora --db-instance-class db.t2.medium
```





# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
