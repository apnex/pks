#!/bin/bash

CRT=$1
DEVICECRT=$(cat $CRT | sed ':a;N;$!ba;s/\n/\\\\n/g')

printf "Writing [certbody]\n" 1>&2
read -r -d '' CONFIG <<CONFIG
{
	"iaas_configuration": {
		"vcenter_host": "vcenter.lab",
		"datacenter": "Datacenter",
		"ephemeral_datastores_string": "ds-esx01",
		"persistent_datastores_string": "ds-esx01",
		"vcenter_username": "administrator@vsphere.local",
		"vcenter_password": "VMware1!",
		"nsx_networking_enabled": true,
		"nsx_mode": "nsx-t",
		"nsx_address": "nsxm01.lab",
		"nsx_username": "admin",
		"nsx_password": "VMware1!VMware1!",
		"nsx_ca_certificate": "$DEVICECRT",
		"bosh_vm_folder": "pcf_vms",
		"bosh_template_folder": "pcf_templates",
		"bosh_disk_path": "pcf_disk",
		"ssl_verification_enabled": false
	},
	"director_configuration": {
		"ntp_servers_string": "pool.ntp.org",
		"metrics_ip": null,
		"resurrector_enabled": true,
		"director_hostname": "",
		"max_threads": 5,
		"disable_dns_release": false,
		"director_worker_count": 5,
		"post_deploy_enabled": true,
		"bosh_recreate_on_next_deploy": false,
		"retry_bosh_deploys": false,
		"keep_unreachable_vms": false,
		"database_type": "internal",
		"hm_pager_duty_options": {
			"enabled": false
		},
		"hm_emailer_options": {
			"enabled": false
		},
		"blobstore_type": "local"
	}
}
CONFIG
printf "$CONFIG" > spec.director.properties.json
printf "$CONFIG"
