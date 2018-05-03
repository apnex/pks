#!/bin/bash
source drv.core

SESSION=$(pks-session)
PRODUCT=$(./drv.product.list.sh | jq -r '.[] | select(.type=="pivotal-container-service").guid')

read -r -d '' BODY <<CONFIG
{
        "instance_type": {
                "id": "micro"
        },
	"instances": "automatic",
        "persistent_disk": {
                "size_mb": "automatic"
        }
}
CONFIG

function updateJob {
	local GUID=${1}
	URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/jobs/$GUID/resource_config"
	RESPONSE=$(curl -k -w "%{http_code}" -X PUT \
	-H "Authorization: Bearer $SESSION" \
	-H "Content-Type: application/json" \
	-d "${BODY}" \
	"$URL" 2>/dev/null)
	printf "$RESPONSE"
}

URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/jobs"
PAYLOAD=$(curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null)

ARRAY=$(echo "${BODY}" | jq .jobs)
for ITEM in $(echo "${ARRAY}" | jq -r '.[] | @base64'); do
	GUID=$(echo ${ITEM} | base64 --decode | jq -r '.guid')
	updateJob "$GUID"
done
