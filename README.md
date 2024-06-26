# Netmaker Helm Chart Repo
<a href="https://github.com/small-hack/netmaker-helm/releases"><img src="https://img.shields.io/github/v/release/small-hack/netmaker-helm?style=plastic&labelColor=blue&color=green&logo=GitHub&logoColor=white"></a>

A Helm chart to run Netmaker with High Availability on Kubernetes.

### Features

Basically everything from [gravitl/netmaker-helm](https://github.com/gravitl/netmaker-helm), but we:

-  organize the values.yaml a little more intuitively by service (UI, MQTT, API, DNS) instead of k8s resource
-  accept existing secrets for sensitive data such as passwords
-  allow users to set an initial super admin user and disable GUI registration
-  have chart testing on new PRs, including a basic install of the chart and linting
-  [autogenerate docs](./charts/netmaker/README.md) from the comments in [`values.yaml`](./charts/netmaker/values.yaml)
-  use RenovateBot to keep the chart/subcharts up to date

## TLDR;

```bash
helm repo add netmaker https://small-hack.github.io/netmaker-helm
helm install netmaker/netmaker --generate-name
```

## Requirements

To run HA Netmaker on Kubernetes, your cluster must have the following:
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

## Status

This is a fork of a fork of [gravitl/netmaker-helm](https://github.com/gravitl/netmaker-helm). This is a bit more actively maintained than the gravitl repo (right now at time of writing in March 2024), and it moves a lot faster, and so it may be slightly unstable as we work out the kinks. Feel free to submit a PR/Issue if you want to add something or if something is broken.
