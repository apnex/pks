#!/bin/bash

#--powerOn \
ovftool \
--name=pks-manager \
--X:injectOvfEnv \
--X:logFile=ovftool.log \
--allowExtraConfig \
--datastore=ds-esx01 \
--net:"Network 1=pg-mgmt" \
--acceptAllEulas \
--noSSLVerify \
--diskMode=thin \
--prop:ip0=172.31.0.3 \
--prop:netmask0=255.255.255.0 \
--prop:gateway=172.31.0.1 \
--prop:DNS=172.16.10.1 \
--prop:ntp_servers=pool.ntp.org \
--prop:admin_password=VMware1! \
--prop:custom_hostname=pks-manager \
pcf-vsphere-2.1-build.204.ova \
vi://administrator@vsphere.local:VMware1%21@vcenter.lab/?ip=172.16.10.101
#pcf-vsphere-2.0-build.264.ova \
