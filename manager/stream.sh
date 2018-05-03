#!/bin/bash
source drv.core

SESSION=$(pks-session)
URL="https://${PKSHOST}/api/v0/installations/current_log"

curl -k -X GET \
-H "Authorization: Bearer $SESSION" \
"$URL"
