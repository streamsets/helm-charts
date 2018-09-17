# StreamSets Control Hub

[StreamSets Control Hub](https://streamsets.com/products/sch)

Collaborative development, automated deployment, scalable execution and governance of multi-pipeline topologies.

For enterprises that desire a disciplined approach to managing multi-pipeline dataflows, Control Hub provides a cloud-native environment for design, deployment, monitoring and maintenance of data movement architectures.

## Introduction

This chart supports both Ingress and Istio Gateway for providing routing and load balancing. Istio is optional, but can be enabled to take advantage of its telemetry and routing capabilities when installing the chart into a namespace with automatic sidecar injection enabled. It has an optional dependency on MySQL. An external SQL database (MySQL or Postgres) can be configured in which case this chart does not manage the database. It does install and configure InfluxDB for time series metrics.

## Installing the Chart

To install the chart with the release name `my-release` into the namespace `streamsets` using a values file named `sch-values.yaml`:

```bash
helm install streamsets/control-hub --name my-release --namespace streamsets --values sch-values.yaml
```

## Configuration

The following tables lists the configurable parameters of the chart and their default values.

| Parameter                            | Description                                                                                | Default                                                                            |
| ------------------------------------ | ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------- |
| `image.repository`                   | Control Hub image name                                                                     | `streamsets/control-hub`                                                           |
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
| `common.env`                         | Environment to set for all app pods                                                        | None                                                                               |
| `appProto`                           | Scheme for app-to-app communication. `http` or `https`.                                    | http                                                                               |
| `apps`                               | List of apps and their app-specific configuration                                          | `replicaCount: 1` plus `common.env`. See values.yaml for detailed app information. |
| `adminPassword`                      | Sets the admin password for the admin app                                                  | Random password\*                                                                  |
| `schInfluxUser`                      | The username to use for InfluxDB                                                           | streamsets                                                                         |
| `schInfluxPassword`                  | The password for the InfluxDB user.                                                        | Random password\*                                                                  |
| `mysql.enabled`                      | Whether to deploy a MySQL instance. If set to false, an external database is required.     | `true`                                                                             |
| `mysql.mysqlRootPassword`            | Root MySQL password to set                                                                 | Random password\*                                                                  |
| `mysql.mysqlUser`                    | MySQL user for SCH apps                                                                    | streamsets                                                                         |
| `mysql.mysqlPassword`                | Password for MySQL user                                                                    | Random password\*                                                                  |
| `mysql.persistence`                  | Create a volume to store data                                                              | `true`                                                                             |
| `mysql.persistence.accessMode`       | ReadWriteOnce or ReadOnly                                                                  | ReadWriteOnce                                                                      |
| `mysql.persistence.size`             | Size of persistent volume claim                                                            | 8Gi                                                                                |
| `mysql.resources`                    | CPU/Memory resource requests/limits                                                        | Memory: `256Mi`, CPU: `100m`                                                       |
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

TODO
