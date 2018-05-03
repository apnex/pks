#### * use the following scripts at your own risk - work in progress *

#### 1: Set up VCSA parameters
Modify the `vcsa-credentials` file to reflect the parameters for your lab.
I recommended using an FQDN of vcenter for the `hostname`.

```json
{
	"hostname": "vcenter.lab",
	"username": "administrator@vsphere.local",
	"password": "VMware1!",
	"domain": "lab",
	"offline": "false"
}
```

#### 2: Set up NSX parameters
Modify the `nsx-credentials` file to reflect the parameters for your lab. I recommended using an IP address for the `hostname`.
The `domain` property will be used in generating/signing a new certificate for the NSX Manager - i.e `*.lab` in this example.

```json
{
	"hostname": "172.16.10.15",
	"username": "admin",
	"password": "VMware1!VMware1!",
	"domain": "lab",
	"offline": "false"
}
```

#### 3: Set up PKS parameters
Modify the `pks-credentials` file to reflect the parameters for your lab. I recommended using an IP address for the `hostname`.
The `domain` property will be used in generating a certificate for the PKS controller - i.e `*.pks.lab` in this example.

```json
{
	"hostname": "172.30.0.3",
	"username": "admin",
	"password": "VMware1!",
	"domain": "pks.lab",
	"offline": "false"
}
```

#### 4: Deploy ops-manager ova
```shell
./pks-manager-deploy.sh
```
- Change LS assignment
- Change Mem assignment
- Power on

#### 5: Configure Internal auth
```shell
./setup.api.sh
```

#### 6: Validate and modify each BOSH director configuration spec as appropriate
```shell
build.spec.sh
spec.director.assign.json
spec.director.az.json
spec.director.job1.json
spec.director.job2.json
spec.director.networks.json
spec.director.properties.json
```

#### 6: Build director property spec with rootCA.pem certificate (for NSX cert)
```shell
./build.spec.sh <root-ca-cert>
```

#### 7: Configure BOSH director
```shell
./director.update.sh
```

#### 8: Begin director deploy
```shell
./director.deploy.sh
```

#### 9: [optional] stream installation log to shell
```shell
./stream.sh
```

#### 10: Upload PKS controller tile
```shell
./controller.upload.sh <pivotal-container-service-1.0.2-build.46.pivotal>
```

#### 11: Check available products
```shell
./get.available.products.sh
```

#### 12: Stage PKS controller
```shell
./controller.stage.sh
```

#### 13: Configure PKS controller
```shell
./controller.update.sh
```

#### 14: Check stemcell assignments
```shell
./stemcell.list.sh
```

#### 15: Upload new 3468.28 trusty stemcell
```shell
./stemcell.upload.sh bosh-stemcell-3468.28-vsphere-esxi-ubuntu-trusty-go_agent.tgz
```

#### 16: Wait for director deployment to complete
#### 17: Deploy pks configuration
