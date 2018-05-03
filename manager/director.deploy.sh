#!/bin/bash
source drv.core

SESSION=$(pks-session)

printf "Triggering Deploy [Director]... "
URL="https://${PKSHOST}/api/v0/installations"
read -r -d '' PAYLOAD <<CONFIG
{
	"deploy_products": "all",
	"ignore_warnings": true
}
CONFIG
RESPONSE=$(curl -k -w "%{http_code}" -X POST \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"

printf "Streaming Installation Log... \n"
URL="https://${PKSHOST}/api/v0/installations/current_log"
curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
"$URL"
