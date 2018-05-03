#/bin/bash
source drv.core

printf "Configuring [AUTH]... "
read -r -d '' PAYLOAD <<CONFIG
{
	"setup": {
		"decryption_passphrase": "VMware1!",
		"decryption_passphrase_confirmation":"VMware1!",
		"eula_accepted": "true",
		"identity_provider": "internal",
		"admin_user_name": "admin",
		"admin_password": "VMware1!",
		"admin_password_confirmation": "VMware1!",
		"no_proxy": "127.0.0.1"
	}
}
CONFIG
URL="https://${PKSHOST}/api/v0/setup"
RESPONSE=$(curl -k -w "%{http_code}" -X POST \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"

