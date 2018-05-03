#!/bin/bash
source drv.core

SESSION=$(pks-session)
PRODUCT=$(./drv.product.list.sh | jq -r '.[] | select(.type=="pivotal-container-service").guid')

function basePut {
	local URL=${1}
	local PAYLOAD=${2}
	local RESPONSE=$(curl -k -w "%{http_code}" -X PUT \
	-H "Authorization: Bearer $SESSION" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	echo "$RESPONSE"
}

printf "Configuring [AZs]... "
URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/networks_and_azs"
BODY=$(cat spec.controller.az.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [API]... "
URL="https://{$PKSHOST}/api/v0/staged/products/$PRODUCT/properties"
BODY=$(cat spec.controller.properties.apikey.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [PLANs]... "
URL="https://{$PKSHOST}/api/v0/staged/products/$PRODUCT/properties"
BODY=$(cat spec.controller.properties.plans.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [CPI]... "
URL="https://{$PKSHOST}/api/v0/staged/products/$PRODUCT/properties"
BODY=$(cat spec.controller.properties.cpi.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [NSX]... "
URL="https://{$PKSHOST}/api/v0/staged/products/$PRODUCT/properties"
BODY=$(cat spec.controller.properties.network.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [UAA]... "
URL="https://{$PKSHOST}/api/v0/staged/products/$PRODUCT/properties"
BODY=$(cat spec.controller.properties.other.json)
RESPONSE=$(basePut "${URL}" "${BODY}")
isSuccess "$RESPONSE"

printf "Configuring [ERRANDs]... "
RESPONSE=$(./drv.controller.errands.update.sh)
isSuccess "$RESPONSE"

printf "Configuring [RESOURCE]... "
RESPONSE=$(./drv.controller.jobs.update.sh)
isSuccess "$RESPONSE"
