#!/bin/bash
source drv.core

SESSION=$(pks-session)

URL="https://${PKSHOST}/api/v0/vm_types"
curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null
