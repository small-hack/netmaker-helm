# Netmaker Helm Chart Repo
A Helm chart to run Netmaker with High Availability on Kubernetes.

![Version: 0.7.2](https://img.shields.io/badge/Version-0.7.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.20.3](https://img.shields.io/badge/AppVersion-0.20.3-informational?style=flat-square)

This is a fork of a fork of [gravitl/netmaker-helm](https://github.com/gravitl/netmaker-helm). This is a bit more actively maintained than the gravitl repo, and it moves a lot faster, and so it may be slightly unstable as we work out the kinks. Feel free to submit a PR/Issue if you want to add something or if something is broken.

<!-- vim-markdown-toc GFM -->

* [Requirements](#requirements)
    * [Example Install](#example-install)
* [Parameters in values.yaml](#parameters-in-valuesyaml)
    * [Kernel WireGuard](#kernel-wireguard)
    * [Ingress Parameters](#ingress-parameters)
    * [Database Parameters](#database-parameters)
    * [MQ Parameters](#mq-parameters)
    * [DNS Parameters](#dns-parameters)
    * [Oauth Parameters](#oauth-parameters)

<!-- vim-markdown-toc -->

## Requirements

To run HA Netmaker on Kubernetes, your cluster must have the following:
- RWO and RWX Storage Classes
- An Ingress Controller and valid TLS certificates 
	- This chart can currently generate ingress for:
		- Nginx Ingress + LetsEncrypt/Cert-Manager
		- Traefik Ingress + LetsEncrypt/Cert-Manager
	- to generate automatically, make sure one of the two is configured for your cluster
- Ability to set up DNS for Secure Web Sockets
	- Nginx Ingress supports Secure Web Sockets (WSS) by default. If you are not using Nginx Ingress, you must route external traffic from broker.domain to the MQTT service, and provide valid TLS certificates.
	- One option is to set up a Load Balancer which routes broker.domain:443 to the MQTT service on port 8883.
	- We do not provide guidance beyond this, and recommend using an Ingress Controller that supports websockets.

Furthermore, the chart will by default install and use the postgresql cluster from [bitnami Postgresql helm chart](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) as its datastore.

### Example Install

```bash
helm repo add netmaker https://gravitl.github.io/netmaker-helm/
helm install netmaker/netmaker --generate-name \ # generate a random id for the deploy 
--set wireguard.kernel=true \ # set wireguard to kernel mode (false by default)
--set baseDomain=nm.example.com \ # the base wildcard domain to use for the netmaker api/dashboard/mq ingress 
--set replicas=1 \ # number of server replicas to deploy (1 by default) 
--set ingress.enabled=true \ # deploy ingress automatically (requires nginx or traefik and cert-manager + letsencrypt) 
--set ingress.className=nginx \ # ingress class to use 
--set ingress.tls.issuerName=letsencrypt-prod \ # LetsEncrypt certificate issuer to use 
--set dns.enabled=true \ # deploy and enable private DNS management with CoreDNS 
--set dns.clusterIP=10.245.75.75 --set dns.RWX.storageClassName=nfs \ # required fields for DNS 
# --set postgresql.readReplicaCount=1 \ # number of DB replicas to deploy (default none)
```

Below, each respective parameter section, we discuss the considerations for Ingress, Kernel WireGuard, and DNS.

## Parameters in values.yaml

| Key                                  | Type   | Default              | Description                                                                                       |
|--------------------------------------|--------|----------------------|---------------------------------------------------------------------------------------------------|
| baseDomain                           | string | `"example.com"`      | the base wildcard domain to use for the netmaker api/dashboard/mq ingress                         |
| persistence.sharedData.existingClaim | string | `""`                 | The name of an existing Persistent Volume Claim to use. If not set, we will create one for you    |
| fullnameOverride                     | string | `""`                 | override the full name for netmaker objects                                                       |
| image.pullPolicy                     | string | `"IfNotPresent"`     | Pull Policy for images                                                                            |
| image.repository                     | string | `"gravitl/netmaker"` | The image repo to pull Netmaker image from                                                        |
| image.tag                            | string | `""`                 | Override the image tag to pull, defaults to [appVersion defined in Chart.yaml] if not specified   |
| nameOverride                         | string | `""`                 | override the name for netmaker objects                                                            |
| podAnnotations                       | object | `{}`                 | pod annotations to add                                                                            |
| podSecurityContext                   | object | `{}`                 | pod security contect to add                                                                       |
| replicas                             | int    | `1`                  | number of netmaker server replicas to create                                                      |
| service.mqPort                       | int    | `443`                | public port for MQ service                                                                        |
| service.restPort                     | int    | `8081`               | port for API service                                                                              |
| service.type                         | string | `"ClusterIP"`        | type for netmaker server services                                                                 |
| service.uiPort                       | int    | `80`                 | port for UI service                                                                               |
| serviceAccount.annotations           | object | `{}`                 | Annotations to add to the service account                                                         |
| serviceAccount.create                | bool   | `true`               | Specifies whether a service account should be created                                             |
| serviceAccount.name                  | string | `""`                 | Name of SA to use. If not set and create is true, a name is generated using the fullname template |
| ui.replicas                          | int    | `1`                  | how many UI replicas to create                                                                    |

### Kernel WireGuard
If you have control of the Kubernetes worker node servers, we recommend **first** installing WireGuard on the hosts, and then installing HA Netmaker in Kernel mode. By default, Netmaker will install with userspace WireGuard (wireguard-go) for maximum compatibility, and to avoid needing permissions at the host level. If you have installed WireGuard on your hosts, you should install Netmaker's helm chart with the following option:
`--set wireguard.kernel=true`

| Key                    | Type | Default | Description                                                                               |
|------------------------|------|---------|-------------------------------------------------------------------------------------------|
| wireguard.kernel       | bool | `false` | whether or not to use Kernel WG (should be false unless WireGuard is installed on hosts). |
| wireguard.networkLimit | int  | `10`    | max number of networks that Netmaker will support if running with WireGuard enabled       |

### Ingress Parameters
To run HA Netmaker, you must have ingress installed and enabled on your cluster with valid TLS certificates (not self-signed). If you are running Nginx as your Ingress Controller and LetsEncrypt for TLS certificate management, you can run the helm install with the following settings:
`--set ingress.enabled=true`
`--set ingress.annotations.cert-manager.io/cluster-issuer=<your LE issuer name>`

If you are not using Nginx and LetsEncrypt, we recommend leaving ingress.enabled=false (default), and then manually creating the ingress objects post-install. You will need three ingress objects with TLS:
`dashboard.<baseDomain>`
`api.<baseDomain>`
`broker.<baseDomain>`

You can find example ingress objects in the kube/example folder.


| Key                                                                              | Type   | Default              | Description                                          |
|----------------------------------------------------------------------------------|--------|----------------------|------------------------------------------------------|
| ingress.annotations.base."kubernetes.io/ingress.allow-http"                      | string | `"false"`            | annotation to generate ACME certs if available       |
| ingress.annotations.nginx."nginx.ingress.kubernetes.io/rewrite-target"           | string | `"/"`                | destination addr for route                           |
| ingress.annotations.nginx."nginx.ingress.kubernetes.io/ssl-redirect"             | string | `"true"`             | Redirect http to https                               |
| ingress.annotations.tls."kubernetes.io/tls-acme"                                 | string | `"true"`             | use acme cert if available                           |
| ingress.annotations.traefik."traefik.ingress.kubernetes.io/redirect-entry-point" | string | `"https"`            | Redirect to https                                    |
| ingress.annotations.traefik."traefik.ingress.kubernetes.io/redirect-permanent"   | string | `"true"`             | Redirect to https permanently                        |
| ingress.annotations.traefik."traefik.ingress.kubernetes.io/rule-type"            | string | `"PathPrefixStrip"`  | rule type                                            |
| ingress.enabled                                                                  | bool   | `false`              | attempts to configure ingress if true                |
| ingress.hostPrefix.mq                                                            | string | `"broker."`          | broker route subdomain                               |
| ingress.hostPrefix.rest                                                          | string | `"api."`             | api (REST) route subdomain                           |
| ingress.hostPrefix.ui                                                            | string | `"dashboard."`       | ui route subdomain                                   |
| ingress.tls.enabled                                                              | bool   | `true`               | enable external traffic to cluster                   |
| ingress.tls.issuerName                                                           | string | `"letsencrypt-prod"` | Name of Issuer or ClusterIssuer to use for TLS certs |

### Database Parameters
To use the bitnami posgresql chart bundled with this chart, set `postgresql.enabled: true`, otherwise, you must provide the connection information using the `externalDatabase` parameters documented below.

| Key                                          | Type   | Default                   | Description                                                                             |
|----------------------------------------------|--------|---------------------------|-----------------------------------------------------------------------------------------|
| postgresql.enabled                           | bool   | `false`                   | Deploys postgresql chart bundled with this helm chart. ignores externalDatabase if set. |
| postgresql.persistence.existingClaim         | string | `""`                      | Existing PVC claim name to use for postgresql                                           |
| postgresql.persistence.size                  | string | `"3Gi"`                   | size of postgres DB                                                                     |
| postgresql.auth.database                     | string | `"netmaker"`              | postgress db to generate                                                                |
| postgresql.auth.password                     | string | `""`                      | postgres pass to generate                                                               |
| postgresql.auth.username                     | string | `"netmaker"`              | postgres user to generate                                                               |
| postgresql.auth.existingSecret               | string | `""`                      | existingSecret for the postgres password, ignores auth.password if set.                 |
| postgresql.auth.secretKeys.userPasswordKey   | string | `""`                      | key in existingSecret for the postgres netmaker password, ignores auth.password if set. |
| postgresql.auth.secretKeys.adminPasswordKey  | string | `""`                      | key in existingSecret for the postgres admin user's password. Admin user is postgres    |
| postgresql.containerPorts.postgresql         | int    | `5342`                    | postgres port                                                                           |
| externalDatabase.host                        | string | `"external.postgres.url"` | external postgres host                                                                  |
| externalDatabase.port                        | int    | `5342`                    | external postgres port                                                                  |
| externalDatabase.database                    | string | `"netmaker"`              | external postgress db                                                                   |
| externalDatabase.password                    | string | `""`                      | external postgres pass                                                                  |
| externalDatabase.username                    | string | `"netmaker"`              | external postgres user                                                                  |
| externalDatabase.auth.existingSecret         | string | `""`                      | existingSecret for the postgres password, ignores auth.password if set.                 |
| externalDatabase.auth.secretKeys.passwordKey | string | `""`                      | key in existingSecret for the postgres password, ignores auth.password if set.          |

### MQ Parameters

The MQ Broker is deployed either with Ingress (Nginx or Traefik) preconfigured, or without. If you are using an ingress controller other than Nginx or Traefik, Netmaker's MQTT will not be complete. "broker.domain"  must reach the MQTT service at port 8883 over WSS (Secure Web Sockets).

| Key               | Type   | Default | Description                                                                       |
|-------------------|--------|---------|-----------------------------------------------------------------------------------|
| mq.existingClaim  | string | `""`    | Existing PVC claim name to use for MQTT                                           |
| mq.username       | string | `""`    | username to set for MQ access                                                     |
| mq.password       | string | `""`    | password to set for MQ access                                                     |
| mq.existingSecret | string | `""`    | Name of the exsiting secret to use for MQTT password instead of using mq.password |
| mq.secretKey      | string | `""`    | Name of the key in mq.existingSecret use for MQTT password                        |

### DNS Parameters
By Default, the helm chart will deploy without DNS enabled. To enable DNS, specify with:
`--set dns.enabled=true` 
This will require specifying a RWX storage class, e.g.:
`--set dns.RWX.storageClassName=nfs`
This will also require specifying a service address for DNS. Choose a valid ipv4 address from the service IP CIDR for your cluster, e.g.:
`--set dns.clusterIP=10.245.69.69`

**This address will only be reachable from hosts that have access to the cluster service CIDR.** It is only designed for use cases related to k8s. If you want a more general-use Netmaker server on Kubernetes for use cases outside of k8s, you will need to do one of the following:
- bind the CoreDNS service to port 53 on one of your worker nodes and set the COREDNS_ADDRESS equal to the public IP of the worker node
- Create a private Network with Netmaker and set the COREDNS_ADDRESS equal to the private address of the host running CoreDNS. For this, CoreDNS will need a node selector and will ideally run on the same host as one of the Netmaker server instances.

| Key               | Type   | Default   | Description                                       |
|-------------------|--------|-----------|---------------------------------------------------|
| dns.enabled       | bool   | `false`   | whether or not to run with DNS (CoreDNS)          |
| dns.existingClaim | string | `""`      | Existing PVC claim name to use for CoreDNS        |
| dns.storageSize   | string | `"128Mi"` | volume size for DNS (only needs to hold one file) |


### Oauth Parameters
To use the an OIDC provider such as azure, google, github, or another provider, set `oauth.enabled: true`.

| Key                           | Type   | Default  | Description                                                                           |
|-------------------------------|--------|----------|---------------------------------------------------------------------------------------|
| oauth.enabled                 | bool   | `false`  | wether or not to use oauth.                                                           |
| oauth.provider                | string | `"oidc"` | Oauth provider to user. Must be one of: azure-ad, github, google, oidc.               |
| oauth.existingSecret          | string | `""`     | existingSecret to use for .                                                           |
| oauth.secretKeys.clientID     | string | `""`     | key in existingSecret for the Client ID to use with the oauth provider                |
| oauth.secretKeys.clientSecret | string | `""`     | key in existingSecret for the Client Secret for the oauth provider                    |
| oauth.secretKeys.frontendURL  | string | `""`     | key in existingSecret for the frontend URL. https://dashboard.<netmaker base domain>? |
| oauth.secretKeys.issuer       | string | `""`     | key in existingSecret for the issuer URL of the oidc provider                         |
| oauth.secretKeys.azureTenant  | string | `""`     | key in existingSecret for the azure tenant. only for azure provider                   |


[appVersion defined in Chart.yaml]: https://github.com/jessebot/netmaker-helm/blob/main/charts/netmaker/Chart.yaml#L24
