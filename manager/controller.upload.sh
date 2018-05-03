#!/bin/bash
source drv.core

SESSION=$(pks-session)
FILE=${1}

URL="https://${PKSHOST}/api/v0/available_products"
curl -k --progress-bar --verbose \
-X POST \
-H "Authorization: Bearer $SESSION" \
-F "product[file]=@${FILE}" \
"$URL"
