#!/bin/bash
source drv.core

SESSION=$(pks-session)

URL="https://${PKSHOST}/v0/staged/products"
BODY=$(./get.available.products.sh | jq '.[] | select(.name=="pivotal-container-service")')

echo "$BODY"
echo "$URL"
curl -k --verbose -X POST \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
-d "${BODY}" \
"$URL"

echo "MOO"

#curl -k -X GET \
#-H "Authorization: Bearer $SESSION" \
#"$URL" 2>/dev/null | jq --tab .
