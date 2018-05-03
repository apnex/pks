#!/bin/bash
source drv.core

function basePut {
	local URL=${1}
	local PAYLOAD=${2}
	local SESSION=$(pks-session)
	local RESPONSE=$(curl -k -w "%{http_code}" -X PUT \
	-H "Authorization: Bearer $SESSION" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	echo "$RESPONSE"
}

printf "Configuring [IAAS]... "
URL="https://${PKSHOST}/api/v0/staged/director/properties"
BODY=$(cat spec.director.properties.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [AZs]... "
URL="https://${PKSHOST}/api/v0/staged/director/availability_zones"
BODY=$(cat spec.director.az.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [Networks]... "
URL="https://${PKSHOST}/api/v0/staged/director/networks"
BODY=$(cat spec.director.networks.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [Assignments]... "
URL="https://${PKSHOST}/api/v0/staged/director/network_and_az"
BODY=$(cat spec.director.assign.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

echo "-- Build Custom VM Types --"
#./vmtype.add.sh 2>/dev/null
./vmtype.list.sh 2>/dev/null

PRODUCT=$(./drv.product.list.sh | jq -r '.[] | select(.type=="p-bosh").guid')
JOBS=$(./drv.director.jobs.list.sh)
JOB1=$(echo "$JOBS" | jq -r '.jobs[] | select(.name=="director").guid')
JOB2=$(echo "$JOBS" | jq -r '.jobs[] | select(.name=="compilation").guid')

printf "Configuring [JOB1]... "
URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/jobs/$JOB1/resource_config"
BODY=$(cat spec.director.job1.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [JOB2]... "
URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/jobs/$JOB2/resource_config"
BODY=$(cat spec.director.job2.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"
