#!/bin/bash
source drv.core

SESSION=$(pks-session)
PRODUCT=$(./drv.product.list.sh | jq -r '.[] | select(.type=="pivotal-container-service").guid')
read -r -d '' BODY <<CONFIG
{
	"errands": [
		{
			"name": "pks-nsx-t-precheck",
			"post_deploy": true
		},
		{
			"name": "upgrade-all-service-instances",
			"post_deploy": true
		},
		{
			"name": "delete-all-clusters",
			"pre_delete": true
		}
	]
}
CONFIG

#GUID=$(echo ${ITEM} | base64 --decode | jq -r '.guid')
URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/errands"
RESPONSE=$(curl -k -w "%{http_code}" -X PUT \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
-d "${BODY}" \
"$URL" 2>/dev/null)
printf "$RESPONSE"
