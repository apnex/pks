#!/bin/bash
source drv.core

SESSION=$(pks-session)

URL="https://${PKSHOST}/api/v0/stemcell_assignments"
curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
"$URL" 2>/dev/null | jq --tab .
