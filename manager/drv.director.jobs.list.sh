#!/bin/bash
source drv.core

SESSION=$(pks-session)
PRODUCT=$(./drv.product.list.sh | jq -r '.[] | select(.type=="p-bosh").guid')

URL="https://${PKSHOST}/api/v0/staged/products/$PRODUCT/jobs"
PAYLOAD=$(curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null)
printf "$PAYLOAD"

function getJob {
	local GUID=${1}
	URL="https://172.30.0.3/api/v0/staged/products/$PRODUCT/jobs/$GUID/resource_config"
	OUT=$(curl -k -X GET \
	-H "Authorization: Bearer $SESSION" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	echo "$OUT"
}
