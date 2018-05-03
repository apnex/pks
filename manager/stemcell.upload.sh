#!/bin/bash
source drv.core

SESSION=$(pks-session)

STEMCELL=$1

URL="https://${PKSHOST}/api/v0/stemcells"
curl -k --progress-bar --verbose "$URL" \
-X POST \
-H "Authorization: Bearer $SESSION" \
-F "stemcell[file]=@$STEMCELL"
