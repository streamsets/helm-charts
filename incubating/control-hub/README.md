# StreamSets Control Hub

[StreamSets Control Hub](https://streamsets.com/products/sch)

Collaborative development, automated deployment, scalable execution and governance of multi-pipeline topologies.

For enterprises that desire a disciplined approach to managing multi-pipeline dataflows, Control Hub provides a cloud-native environment for design, deployment, monitoring and maintenance of data movement architectures.

## Incubating Status

The status of this chart is `incubating` and as such you may still encounter issues.

During the beta period, if you are an existing customer, you can apply for access by filling out the following form:
https://goo.gl/forms/i76juwY3ZqS2il3l2

## Introduction

_StreamSets Control Hub is licensed software, and access to the image used in this chart is not public. You must also have a valid Control Hub license key to install this software._

This chart supports both Ingress and Istio Gateway for providing routing and load balancing. Istio is optional, but can be enabled to take advantage of its telemetry and routing capabilities when installing the chart into a namespace with automatic sidecar injection enabled. It has an optional dependency on MySQL. An external SQL database (MySQL or Postgres) can be configured in which case this chart does not manage the database. It does install and configure InfluxDB for time series metrics.

## Installing the Chart

First, add the streamsets incubating repository to helm.

```bash
helm repo add streamsets-incubating https://streamsets.github.io/helm-charts/incubating
```

To install the chart with the release name `my-release` into the namespace `streamsets` using a values file named `sch-values.yaml`:

```bash
helm install streamsets-incubating/control-hub --name my-release --namespace streamsets --values <path-to>/sch-values.yaml
```

Typical minimal configuration for `sch-values.yaml` looks like:

```yaml
fullnameOverride: sch
image:
  repository: streamsets/control-hub
  tag: 3.13.0-SNAPSHOT
  pullSecret: myregistrykey
  pullPolicy: Always
ingress:
  proto: https
  domain: yourdomain-name.com
  host: sch
  annotations:
    kubernetes.io/ingress.allow-http: "true"
    kubernetes.io/ingress.class: traefik
systemDataCollector:
  enabled: true
```

#### Database deployment

Currently this chart deploys MySQL and work is underway to more readily support "bring your own" database.

For now it is advised for Proof of Concept purposes to use the included MySQL database and set your own username/passwords for upgradability.

This can be achieved at the command line during install:
```bash
helm install incubating/control-hub --name sch --namespace streamsets --values <path-to>>/sch-values.yaml --set mysql.mysqlUser=<user>,mysql.mysqlPassword=<password>
```

or by appending the following to your `sch-values.yaml`:

```yaml
mysql:
  enabled: true
  mysqlRootPassword: root
  mysqlUser: streamsets
  mysqlPassword: root
```

#### Upgrading
```bash
helm upgrade -f <path-to>/sch-values.yaml sch ./incubating/control-hub --set image.tag=<new image>
```

#### Deleting

The following command functions as expected:
```bash
helm delete --purge sch
```

Yet depending on the install state when this is executed, k8s jobs may be still queued. It is advised to:

```bash
kubectl get all -n streamsets
```

and delete manually using `kubectl delete job <job>` where required.


## Custom Configuration Tips

You will need to configure a ServiceEntry and VirtualService for your mail server if it is outside of the service mesh when Istio is enabled.

For example:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: mailjet
spec:
  hosts:
    - in-v3.mailjet.com
  ports:
    - number: 2525
      name: smtp
      protocol: TCP
  resolution: DNS
  location: MESH_EXTERNAL
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: mailjet
spec:
  hosts:
    - in-v3.mailjet.com
  tls:
    - match:
        - port: 2525
          sni_hosts:
            - in-v3.mailjet.com
      route:
        - destination:
            host: in-v3.mailjet.com
            port:
              number: 2525
          weight: 100
```

### Deploy apps in minikube with `pipelinestore` in one container and all other apps in another container


```yaml
  image:
    pullPolicy: Never
  ingress:
    enabled: false
    proto: http
    # Used to create an Ingress record.
    domain: minikube.local
    host: streamsets
    annotations:
  istio:
    enabled: true
    mTLS: PERMISSIVE

  adminPassword: streamSets123
  schInfluxPassword: streamSets123

  common:
    env: &COMMON_ENV
      DPM_JAVA_OPTS: "-Xms128m -Xmx1024m"

  deployments:
  - name: one
    appsToStart: "security,messaging,jobrunner,topology,notification,sla,policy,provisioning,scheduler,sdp_classification,reporting"
    replicaCount: 1
    container:
      env:
        <<: *COMMON_ENV
  - name: pipelinestore
    appsToStart: "pipelinestore"
    replicaCount: 1
    container:
      env:
        <<: *COMMON_ENV
        DPM_JAVA_OPTS: "-Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5006,suspend=n"

  appProto: http
  apps:
  - name: security
    deployment: one
  - name: pipelinestore
    deployment: pipelinestore
  - name: messaging
    deployment: one
  - name: jobrunner
    deployment: one
  - name: timeseries
    deployment: one
  - name: topology
    deployment: one
  - name: notification
    deployment: one
  - name: sla
    deployment: one
  - name: policy
    deployment: one
  - name: provisioning
    deployment: one
  - name: scheduler
    deployment: one
  - name: sdp_classification
    deployment: one
  - name: reporting
    deployment: one

  mysql:
    mysqlRootPassword: streamSets123
    mysqlPassword: streamSets123
```

## All Configuration Options

The following tables lists the configurable parameters of the chart and their default values.

| Parameter                              | Description                                                                                | Default                                                    |
| -------------------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------- |
| `image.repository`                     | Control Hub image name                                                                     | `streamsets-incubating/control-hub`                        |
| `image.tag`                            | The version of the official image to use                                                   | `latest`                                                   |
| `image.pullPolicy`                     | Pull policy for the image                                                                  | `IfNotPresent`                                             |
| `service.type`                         | Service resource type. Typically ClusterIP                                                 | `ClusterIP`                                                |
| `service.port`                         | Service Port                                                                               | `18631`                                                    |
| `service.adminPort`                    | Admin UI Service Port                                                                      | `18632`                                                    |
| `ingress.enabled`                      | Whether to create Ingress resources. Typically mutually exclusive to `istio.enabled`       | `true`                                                     |
| `ingress.proto`                        | Scheme for Ingress/Istio Gateway (http or https)                                           | `https`                                                    |
| `ingress.domain`                       | The FQDN minus hostname that users will visit                                              | example.com                                                |
| `ingress.host`                         | The hostname part of the FQDN that users will visit                                        | streamsets                                                 |
| `ingress.annotations`                  | Optional list of annotations to apply to the Ingress resource                              | None                                                       |
| `istio.enabled`                        | When set to true, will create Istio Gateway/Virtual Service resources instead of Ingress.  |
| `istio.mTLS`                           | Sets the Istio authentication policy to either PERMISSIVE/ISTIO_MUTUAL, or DISABLE         |
| `resources`                            | Resource request for the pods                                                              | None                                                       |
| `nodeSelector`                         | Node selector for the pods                                                                 | None                                                       |
| `mailProtocol`                         | Whether to use the SMTP or SMTPS protocol for sending email.                               | `smtp`                                                     |
| `mailStarttls`                         | Whether to enable StartTLS. Used only with the `smtp` protocol.                            | `true`                                                     |
| `mailHost`                             | Mail server hostname                                                                       | None                                                       |
| `mailPort`                             | Mail server port number                                                                    | `587` for `smtp` and `465` for `smtps`                     |
| `mailUsername`                         | Username if required                                                                       | None                                                       |
| `mailPassword`                         | Password if required                                                                       | None                                                       |
| `mailFromAddress`                      | From address of email sent by Control Hub                                                  | `no-reply@streamsets.com`                                  |
| `systemDataCollector.enabled`          | Whether to install a system Data Collector                                                 | `true`                                                     |
| `systemDataCollector.image.repository` | Control Hub image name                                                                     | `streamsets/datacollector`                                 |
| `systemDataCollector.image.tag`        | The version of the official image to use                                                   | `latest`                                                   |
| `systemDataCollector.image.pullPolicy` | Pull policy for the image                                                                  | `IfNotPresent`                                             |
| `systemDataCollector.resources`        | Resource request for the pods                                                              | None                                                       |
| `systemDataCollector.nodeSelector`     | Node selector for the pods                                                                 | None                                                       |
| `common.env`                           | Environment to set for all app pods                                                        | None                                                       |
| `appProto`                             | Scheme for app-to-app communication. `http` or `https`.                                    | `http`                                                     |
| `apps`                                 | List of app services and their associated `group`                                          |                                                            |
| `apps.name`                            | Name of service for app                                                                    |                                                            |
| `apps.deployment`                      | Deployment name for service found in `deployments`                                         | `apps.name`                                                |
| `deployments`                          | Deployment specific information related to SERVICES in `apps`                              | A `deployment` per app service.                            |
| `deployments.name`                     | Label for deployment. Used to associate app service to this deployment                     | `apps.name`                                                |
| `deployments.appsToStart`              | List of apps to start in this deployment                                                   | `apps.name`                                                |
| `deployments.replicaCount`             | Number of replicas for this deployment                                                     | `1`                                                        |
| `deployments.env`                      | App specific environment settings.                                                         | See values.yaml `common.env` for detailed app information. |
|                                        |
| `adminPassword`                        | Sets the admin password for the admin app                                                  | Random password\*                                          |
|                                        |
| `mysql.enabled`                        | Whether to deploy a MySQL instance. If set to false, an external database is required.     | `true`                                                     |
| `mysql.mysqlRootPassword`              | Root MySQL password to set                                                                 | Random password\*                                          |
| `mysql.mysqlUser`                      | MySQL user for SCH apps                                                                    | `streamsets`                                               |
| `mysql.mysqlPassword`                  | Password for MySQL user                                                                    | Random password\*                                          |
| `mysql.persistence`                    | Create a volume to store data                                                              | `true`                                                     |
| `mysql.persistence.accessMode`         | ReadWriteOnce or ReadOnly                                                                  | ReadWriteOnce                                              |
| `mysql.persistence.size`               | Size of persistent volume claim                                                            | 8Gi                                                        |
| `mysql.resources`                      | CPU/Memory resource requests/limits                                                        | Memory: `256Mi`, CPU: `100m`                               |
|                                        |
| `schInfluxUser`                        | The username to use for InfluxDB                                                           | `streamsets`                                               |
| `schInfluxPassword`                    | The password for the InfluxDB user.                                                        | Random password\*                                          |
| `influxdb.proto`                       | Scheme for InfluxDB API (http or https)                                                    | `http`                                                     |
| `influxdb.enabled`                     | Whether to deploy an InfluxDB instance. If set to false, an external instance is required. | `true`                                                     |
| `influxdb.image.tag`                   | Version of InfluxDB to use                                                                 | 1.3                                                        |
| `influxdb.persistence`                 | Whether to use a persistent volume claim for storage                                       | `true`                                                     |
| `influxdb.persistence.size`            | Size of persistent volume claim                                                            | 8Gi                                                        |
| `influxdb.config.reporting_disabled`   | Whether to enable usage reporting to InfluxData                                            | `false`                                                    |
| `influxdb.http.bind_address`           | Port to use for InfluxDB API                                                               | `8086`                                                     |

_Note: See [MySQL chart readme](https://github.com/helm/charts/blob/master/stable/mysql/README.md) for more detailed MySQL configuration options as well as the values.yaml for this chart._
_Note: Dynamic scaling is not supported with random passwords_
