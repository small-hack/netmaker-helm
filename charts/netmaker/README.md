# netmaker

![Version: 0.10.0](https://img.shields.io/badge/Version-0.10.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.21.2](https://img.shields.io/badge/AppVersion-v0.21.2-informational?style=flat-square)

A Helm chart to run HA Netmaker on Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| jessebot | <jessebot@linux.com> | <https://github.com/jessebot/> |
| cloudymax | <emax@cloudydev.net> | <https://github.com/cloudymax/> |

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
| externalDatabase.existingSecret | string | `""` |  |
| externalDatabase.host | string | `"external.postgres.url"` | postgres host |
| externalDatabase.password | string | `""` | postgres pass for netmaker user. ignored if existingSecret is set |
| externalDatabase.port | int | `5432` | postgres hosts port |
| externalDatabase.secretKeys.passwordKey | string | `""` |  |
| externalDatabase.type | string | `"postgresql"` |  |
| externalDatabase.username | string | `"netmaker"` | postgres username |
| fullnameOverride | string | `""` | override the full name for netmaker objects |
| image.pullPolicy | string | `"IfNotPresent"` | Pull Policy for images |
| image.repository | string | `"gravitl/netmaker"` | The image repo to pull Netmaker image from |
| mq.affinity | object | `{}` | optional affinity settings for mqtt |
| mq.existingSecret | string | `""` | name of an existing secret to use for mq password. If set, ignores mq.password |
| mq.generateCert | bool | `false` |  |
| mq.ingress.annotations | object | `{}` | annotations for the mqtt ingress object |
| mq.ingress.className | string | `"nginx"` |  |
| mq.ingress.enabled | bool | `true` | attempts to configure ingress if true |
| mq.ingress.host | string | `"broker.cluster.local"` | hostname for mqtt ingress |
| mq.ingress.tls | list | `[]` | ingress tls list |
| mq.password | string | `""` |  |
| mq.persistence.accessMode | string | `"ReadWriteMany"` |  |
| mq.persistence.existingClaim | string | `""` | name of existing PVC claim to use. if set, storageClassName is ignored |
| mq.persistence.storage | string | `"128Mi"` |  |
| mq.persistence.storageClassName | string | `""` |  |
| mq.replicas | int | `1` | how many MQTT replicas to create |
| mq.secretKey | string | `""` | name of key in existing secret to grab password from. If set, ignores mq.password |
| mq.service.port | int | `443` | port for MQTT service |
| mq.service.targetPort | int | `8883` | Target port for MQTT service |
| mq.service.type | string | `"ClusterIP"` | type for netmaker server services |
| mq.tolerations | object | `{}` | optional tolerations settings for mqtt |
| mq.username | string | `"netmaker"` |  |
| nameOverride | string | `""` | override the name for netmaker objects |
| oauth.enabled | bool | `false` |  |
| oauth.existingSecret | string | `""` |  |
| oauth.provider | string | `"oidc"` |  |
| oauth.secretKeys.clientID | string | `nil` |  |
| oauth.secretKeys.clientSecret | string | `nil` |  |
| oauth.secretKeys.frontendURL | string | `nil` |  |
| oauth.secretKeys.issuer | string | `nil` |  |
| podAnnotations | object | `{}` | pod annotations to add |
| podSecurityContext | object | `{}` | pod security contect to add |
| postgresql.auth.database | string | `"netmaker"` |  |
| postgresql.auth.existingSecret | string | `""` |  |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.primary.persistence.enabled | bool | `true` |  |
| postgresql.auth.secretKeys.adminPasswordKey | string | `""` |  |
| postgresql.auth.secretKeys.userPasswordKey | string | `""` |  |
| postgresql.auth.username | string | `"netmaker"` |  |
| postgresql.enabled | bool | `true` |  |
| replicas | int | `1` | number of netmaker server replicas to create |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | Name of SA to use. If not set and create is true, a name is generated using the fullname template |
| setIpForwarding.enabled | bool | `true` |  |
| tolerations | object | `{}` | optional tolerations settings for netmaker |
| ui.ingress.annotations | object | `{}` | annotations for the netmaker UI ingress object |
| ui.ingress.className | string | `"nginx"` | UI ingress className |
| ui.ingress.enabled | bool | `true` | attempts to configure ingress if true |
| ui.ingress.host | string | `"dashboard.cluster.local"` | hostname for mqtt ingress |
| ui.ingress.tls | list | `[]` | ingress tls list |
| ui.replicas | int | `1` | how many UI replicas to create |
| ui.service.port | int | `80` | port for UI service |
| ui.service.targetport | int | `80` | target port for UI service |
| ui.service.type | string | `"ClusterIP"` | type for netmaker server services |
| wireguard.enabled | bool | `true` | whether or not to use WireGuard on server |
| wireguard.kernel | bool | `false` | whether or not to use Kernel WG (should be false unless WireGuard is installed on hosts). |
| wireguard.networkLimit | int | `10` | max number of networks that Netmaker will support if running with WireGuard enabled |
| wireguard.service.annotations | object | `{}` |  |
| wireguard.service.type | string | `"NodePort"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
