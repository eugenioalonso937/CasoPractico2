#!/bin/bash

az vm image accept-terms --urn cognosys:centos-8-stream-free:centos-8-stream-free:1.2019.0810

terraform init
terraform apply
