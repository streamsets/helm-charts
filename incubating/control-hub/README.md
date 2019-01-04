# StreamSets Control Hub

[StreamSets Control Hub](https://streamsets.com/products/sch)

Collaborative development, automated deployment, scalable execution and governance of multi-pipeline topologies.

For enterprises that desire a disciplined approach to managing multi-pipeline dataflows, Control Hub provides a cloud-native environment for design, deployment, monitoring and maintenance of data movement architectures.

## Introduction

This chart supports both Ingress and Istio Gateway for providing routing and load balancing. Istio is optional, but can be enabled to take advantage of its telemetry and routing capabilities when installing the chart into a namespace with automatic sidecar injection enabled. It has an optional dependency on MySQL. An external SQL database (MySQL or Postgres) can be configured in which case this chart does not manage the database. It does install and configure InfluxDB for time series metrics.

## Installing the Chart

First, add the streamsets incubating repository to helm.

```bash
helm repo add streamsets-incubating https://streamsets.github.io/helm-charts/incubating
```

To install the chart with the release name `my-release` into the namespace `streamsets` using a values file named `sch-values.yaml`:

```bash
helm install streamsets-incubating/control-hub --name my-release --namespace streamsets --values sch-values.yaml
```

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

| Parameter                            | Description                                                                                | Default                                                                            |
| ------------------------------------ | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------- |
| `image.repository`                   | Control Hub image name                                                                     | `streamsets-incubating/control-hub`                                                           |
| `image.tag`                          | The version of the official image to use                                                   | `latest`                                                                           |
| `image.pullPolicy`                   | Pull policy for the image                                                                  | `IfNotPresent`                                                                     |
| `service.type`                       | Service resource type. Typically ClusterIP                                                 | ClusterIP                                                                          |
| `service.port`                       | Service Port                                                                               | `18631`                                                                            |
| `service.adminPort`                  | Admin UI Service Port                                                                      | `18632`                                                                            |
| `ingress.enabled`                    | Whether to create Ingress resources. Typically mutually exclusive to `istio.enabled`       | `true`                                                                             |
| `ingress.proto`                      | Scheme for Ingress/Istio Gateway (http or https)                                           | https                                                                              |
| `ingress.domain`                     | The FQDN minus hostname that users will visit                                              | example.com                                                                        |
| `ingress.host`                       | The hostname part of the FQDN that users will visit                                        | streamsets                                                                         |
| `ingress.annotations`                | Optional list of annotations to apply to the Ingress resource                              | None                                                                               |
| `istio.enabled`                      | When set to true, will create Istio Gateway/Virtual Service resources instead of Ingress.  |
| `istio.mTLS`                         | Sets the Istio authentication policy to either PERMISSIVE/ISTIO_MUTUAL, or DISABLE         |
| `resources`                          | Resource request for the pods                                                              | None                                                                               |
| `nodeSelector`                          | Node selector for the pods                                                              | None                                                                               |
| `systemDataCollector.enabled` | Whether to install a system Data Collector | true |
| `systemDataCollector.image.repository`                   | Control Hub image name                                                                     | `streamsets/datacollector`                                                           |
| `systemDataCollector.image.tag`                          | The version of the official image to use                                                   | `latest`                                                                           |
| `systemDataCollector.image.pullPolicy`                   | Pull policy for the image                                                                  | `IfNotPresent`                                                                     |
| `systemDataCollector.resources`                          | Resource request for the pods                                                              | None                                                                               |
| `systemDataCollector.nodeSelector`                          | Node selector for the pods                                                              | None                                                                               |
| `common.env`                         | Environment to set for all app pods                                                        | None                                                                               |
| `appProto`                           | Scheme for app-to-app communication. `http` or `https`.                                    | http                                                                               |
| `apps`                               | List of app services and their associated `group`              |  |
| `apps.name`                          | Name of service for app              |  |
| `apps.deployment`                    | Deployment name for service found in `deployments`   | `apps.name` |
| `deployments`                        | Deployment specific information related to SERVICES in `apps`   | A `deployment` per app service. |
| `deployments.name`                   | Label for deployment. Used to associate app service to this deployment           | `apps.name`|
| `deployments.appsToStart`             | List of apps to start in this deployment                                         | `apps.name` |
| `deployments.replicaCount`            | Number of replicas for this deployment                                          | 1 |
| `deployments.env`                    | App specific environment settings.                              | See values.yaml `common.env` for detailed app information.|
||
| `adminPassword`                      | Sets the admin password for the admin app                                                  | Random password\*                                                                  |
||
| `mysql.enabled`                      | Whether to deploy a MySQL instance. If set to false, an external database is required.     | `true`                                                                             |
| `mysql.mysqlRootPassword`            | Root MySQL password to set                                                                 | Random password\*                                                                  |
| `mysql.mysqlUser`                    | MySQL user for SCH apps                                                                    | streamsets                                                                         |
| `mysql.mysqlPassword`                | Password for MySQL user                                                                    | Random password\*                                                                  |
| `mysql.persistence`                  | Create a volume to store data                                                              | `true`                                                                             |
| `mysql.persistence.accessMode`       | ReadWriteOnce or ReadOnly                                                                  | ReadWriteOnce                                                                      |
| `mysql.persistence.size`             | Size of persistent volume claim                                                            | 8Gi                                                                                |
| `mysql.resources`                    | CPU/Memory resource requests/limits                                                        | Memory: `256Mi`, CPU: `100m`                                                       |
||
|`schInfluxUser`                      | The username to use for InfluxDB                                                           | streamsets                                                                         |
| `schInfluxPassword`                  | The password for the InfluxDB user.                                                        | Random password\*                                                                  |
| `influxdb.proto`                     | Scheme for InfluxDB API (http or https)                                                    | http                                                                               |
| `influxdb.enabled`                   | Whether to deploy an InfluxDB instance. If set to false, an external instance is required. | `true`                                                                             |
| `influxdb.image.tag`                 | Version of InfluxDB to use                                                                 | 1.3                                                                                |
| `influxdb.persistence`               | Whether to use a persistent volume claim for storage                                       | `true`                                                                             |
| `influxdb.persistence.size`          | Size of persistent volume claim                                                            | 8Gi                                                                                |
| `influxdb.config.reporting_disabled` | Whether to enable usage reporting to InfluxData                                            | `false`                                                                            |
| `influxdb.http.bind_address`         | Port to use for InfluxDB API                                                               | `8086`                                                                             |

_Note: See [MySQL chart readme](https://github.com/helm/charts/blob/master/stable/mysql/README.md) for more detailed MySQL configuration options as well as the values.yaml for this chart._

_Note: Dynamic scaling is not supported with random passwords_

## Custom Configuration Tips

### Deploy apps in minikube with `pipelinestore` in one container and all other apps in another container.

``` ---
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
       DPM_CONF_MAIL_TRANSPORT_PROTOCOL: smtp
       DPM_CONF_MAIL_SMTP_HOST:
       DPM_CONF_MAIL_SMTP_PORT: 587
       DPM_CONF_MAIL_SMTP_STARTTLS_ENABLE: true
       DPM_CONF_MAIL_SMTP_AUTH: true
       DPM_CONF_MAIL_SMTPS_HOST:
       DPM_CONF_MAIL_SMTPS_PORT: 465
       DPM_CONF_MAIL_SMTPS_AUTH: true
       DPM_CONF_XMAIL_USERNAME:
       DPM_CONF_XMAIL_PASSWORD:
       DPM_CONF_XMAIL_FROM_ADDRESS:

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
     imageTag: 5.7
     mysqlRootPassword: streamSets123
     mysqlPassword: streamSets123
     podAnnotations:
       sidecar.istio.io/inject: "false"
```
