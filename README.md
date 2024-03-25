# netmaker

![Version: 0.10.0](https://img.shields.io/badge/Version-0.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.21.2](https://img.shields.io/badge/AppVersion-v0.21.2-informational?style=flat-square)

A Helm chart to run HA Netmaker on Kubernetes

[b]Chart source[/b]: [github.com/small-hack/netmaker-helm](https://github.com/small-hack/netmaker-helm/tree/main)

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jessebot  | <https://github.com/jessebot/> |
| cloudymax | <https://github.com/cloudymax/> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | postgresql | 15.1.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | optional affinity settings for netmaker |
| api.ingress.annotations | object | `{}` | annotations for the netmaker API ingress object |
| api.ingress.className | string | `"nginx"` | api ingress className |
| api.ingress.enabled | bool | `true` | attempts to configure ingress if true |
| api.ingress.host | string | `"api.cluster.local"` | api (REST) route subdomain |
| api.ingress.tls | list | `[]` | ingress api tls list |
| api.service.port | int | `8081` | port for API service |
| api.service.targetPort | int | `8081` | targetport for API service |
| api.service.type | string | `"ClusterIP"` | type for netmaker server services |
| dns.enabled | bool | `false` | whether or not to deploy coredns |
| dns.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| dns.persistence.existingClaim | string | `""` | existingClaim, if not set, defaults to HELM.RELEASE.NAME-dns |
| dns.persistence.storage | string | `"1Gi"` |  |
| dns.persistence.storageClassName | string | `""` |  |
| externalDatabase.database | string | `"netmaker"` | postgress db |
| externalDatabase.existingSecret | string | `""` | use existing secret for netmaker db credentials, must have the following keys: SQL_PASS, SQL_HOST, SQL_PORT, SQL_USER, SQL_DB |
| externalDatabase.host | string | `"external.postgres.url"` | postgres host |
| externalDatabase.password | string | `""` | postgres pass for netmaker user. ignored if existingSecret is set |
| externalDatabase.port | int | `5432` | postgres hosts port |
| externalDatabase.type | string | `"postgresql"` |  |
| externalDatabase.username | string | `"netmaker"` | postgres username |
| fullnameOverride | string | `""` | override the full name for netmaker objects |
| image.pullPolicy | string | `"IfNotPresent"` | Pull Policy for images |
| image.repository | string | `"gravitl/netmaker"` | The image repo to pull Netmaker image from |
| mq.affinity | object | `{}` | optional affinity settings for mqtt |
| mq.existingSecret | string | `""` | name of an existing secret to use for mq password. If set, ignores mq.password, mq.username secret keys must be: MQ_PASSWORD, MQ_USERNAME |
| mq.generateCert | bool | `false` |  |
| mq.ingress.annotations | object | `{}` | annotations for the mqtt ingress object |
| mq.ingress.className | string | `"nginx"` |  |
| mq.ingress.enabled | bool | `true` | attempts to configure ingress if true |
| mq.ingress.host | string | `"broker.cluster.local"` | hostname for mqtt ingress |
| mq.ingress.tls | list | `[]` | ingress tls list |
| mq.password | string | `""` |  |
| mq.replicas | int | `1` | how many MQTT replicas to create |
| mq.service.port | int | `443` | port for MQTT service |
| mq.service.targetPort | int | `8883` | Target port for MQTT service |
| mq.service.type | string | `"ClusterIP"` | type for netmaker server services |
| mq.tolerations | object | `{}` | optional tolerations settings for mqtt |
| mq.username | string | `"netmaker"` |  |
| nameOverride | string | `""` | override the name for netmaker objects |
| netmaker.enterprise | object | `{"licenseKey":"","tenantId":""}` | if using enterprise edition fill out this section |
| netmaker.enterprise.licenseKey | string | `""` | netmaker enterprise license key, ignored if netmaker.existingSecret set |
| netmaker.enterprise.tenantId | string | `""` | netmaker enterprise tenant ID, ignored if netmaker.existingSecret set |
| netmaker.existingSecret | string | `""` | if set ignores netmaker.masterKey and enterprise.* must have key called MASTER_KEY, optionally for enterprise must have key: LICENSE_KEY, NETMAKER_TENANT_ID |
| netmaker.jwtDuration | int | `43200` | Duration of JWT token validity in seconds |
| netmaker.masterKey | string | `"netmaker"` | ignored if netmaker.masterKeyExistingSecret is set |
| netmaker.oauth.azureTenant | string | `""` | azureTenant if using azure for oauth - ignored if netmaker.oauth.existingSecret is set |
| netmaker.oauth.clientID | string | `""` | client id if using oidc - ignored if netmaker.oauth.existingSecret is set |
| netmaker.oauth.clientSecret | string | `""` | client secret if using oidc - ignored if netmaker.oauth.existingSecret is set |
| netmaker.oauth.enabled | bool | `false` |  |
| netmaker.oauth.existingSecret | string | `""` | existing secret for oauth, must have the following keys: CLIENT_ID, CLIENT_SECRET, OIDC_ISSUER, and optionally AZURE_TENANT ignores plane text values if this is set |
| netmaker.oauth.issuer | string | `""` | oidc issuer - ignored if netmaker.oauth.existingSecret is set |
| netmaker.oauth.provider | string | `"oidc"` | AUTH_PROVIDER: must be one of: azure-ad|github|google|oidc |
| netmaker.racAutoDisable | string | `"true"` | Auto disable a user's connecteds clients bassed on JWT token expiration |
| netmaker.serverName | string | `"cluster.local"` |  |
| podAnnotations | object | `{}` | pod annotations to add |
| podSecurityContext | object | `{}` | pod security contect to add |
| postgresql.auth.database | string | `"netmaker"` |  |
| postgresql.auth.existingSecret | string | `""` | use existing secret for netmaker db credentials, must have the following keys: SQL_PASS, SQL_HOST, SQL_PORT, SQL_USER, SQL_DB |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.primary.persistence.enabled | bool | `true` |  |
| postgresql.auth.username | string | `"netmaker"` |  |
| postgresql.enabled | bool | `true` |  |
| replicas | int | `1` | number of netmaker server replicas to create |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | Name of SA to use. If not set and create is true, a name is generated using the fullname template |
| setIpForwarding.enabled | bool | `true` |  |
| shared_data.persistence.accessMode | string | `"ReadWriteMany"` |  |
| shared_data.persistence.existingClaim | string | `""` | name of existing PVC claim to use. if set, storageClassName is ignored |
| shared_data.persistence.storage | string | `"128Mi"` |  |
| shared_data.persistence.storageClassName | string | `""` |  |
| tolerations | object | `{}` | optional tolerations settings for netmaker |
| turn.apiHost | string | `""` |  |
| turn.enabled | bool | `false` | use an external turn server |
| turn.existingSecret | string | `""` | existing secret with turn server info. Must have the following keys: TURN_SERVER_HOST, TURN_SERVER_API_HOST, TURN_PORT, TURN_USERNAME, TURN_PASSWORD |
| turn.host | string | `""` |  |
| turn.password | string | `""` |  |
| turn.username | string | `""` |  |
| ui.ingress.annotations | object | `{}` | annotations for the netmaker UI ingress object |
| ui.ingress.className | string | `"nginx"` | UI ingress className |
| ui.ingress.enabled | bool | `true` | attempts to configure ingress if true |
| ui.ingress.host | string | `"dashboard.cluster.local"` | hostname for mqtt ingress |
| ui.ingress.tls | list | `[]` | ingress tls list |
| ui.replicas | int | `1` | how many UI replicas to create |
| ui.service.port | int | `80` | port for UI service |
| ui.service.targetport | int | `80` | target port for UI service |
| ui.service.type | string | `"ClusterIP"` | type for netmaker server services |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
