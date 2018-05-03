#!/bin/bash
source drv.core

RAW=$1
PAYLOAD=$(./drv.vmtype.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.vm_types |
		["name", "ram", "cpu", "ephemeral_disk", "builtin"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.name, .ram, .cpu, .ephemeral_disk, .builtin])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD"
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
