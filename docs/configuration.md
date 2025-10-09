# VictoriaLogs Configuration Guide

This guide details all configuration options available in the VictoriaLogs BOSH release.

## VictoriaLogs Single-Node Configuration

The single-node `victorialogs` job runs as a Docker container and provides a simple deployment option for smaller environments.

### Forwarding Cloud Foundry Logs
Add the following ops file to `cf-deployment` to ship Cloud Foundry component logs into
VictoriaLogs. Supply the referenced variables via `-v` flags or a vars store.

```yaml
# operations/victorialogs-syslog-forwarder.yml
---
- type: replace
  path: /releases?/name=syslog
  value:
    name: syslog
    version: 11.13.0

- type: replace
  path: /addons?/-
  value:
    name: victorialogs-syslog-forwarder
    include:
      jobs:
      - name: /.+/
    jobs:
    - name: syslog_agent
      release: syslog
      properties:
        syslog:
          address: ((victorialogs_syslog_host))
          port: ((victorialogs_syslog_port))
          transport: tcp
          tls:
            enabled: ((victorialogs_syslog_tls_enabled))
            skip_cert_verify: false
            ca_cert: ((victorialogs_syslog_ca.certificate))
            cert: ((victorialogs_syslog_client.certificate))
            key: ((victorialogs_syslog_client.private_key))
            server_name: ((victorialogs_syslog_tls_cn))
          queue_size: 65536
          fallback_servers: []
        syslog_agent:
          disable: false

- type: replace
  path: /variables?/-
  value:
    name: victorialogs_syslog_client
    type: certificate
    options:
      ca: victorialogs_syslog_ca
      common_name: victorialogs-syslog-client
      extended_key_usage: [client_auth]
```

```bash
bosh deploy cf-deployment.yml \
  -o operations/victorialogs-syslog-forwarder.yml \
  -v victorialogs_syslog_host=<vlinsert-ip> \
  -v victorialogs_syslog_port=514 \
  -v victorialogs_syslog_tls_enabled=true
```

For cluster deployments, ensure the vlinsert job has syslog listening enabled
(`vlinsert.syslog_listen_addr: ":514"`). Application logs still require app-level syslog drains, and
you should verify delivery post-deploy by tailing the `syslog_agent` logs via `bosh ssh`.

### victorialogs.port
- **Description**: Port for VictoriaLogs HTTP API
- **Default**: 9428
- **Type**: Integer

### victorialogs.container_image
- **Description**: Docker image for VictoriaLogs
- **Default**: docker.io/victoriametrics/victoria-logs:v1.35.0
- **Type**: String

### victorialogs.storage_path
- **Description**: Path for persistent storage of logs
- **Default**: /var/vcap/store/victorialogs/data
- **Type**: String

### victorialogs.retention_period
- **Description**: Log retention period (e.g., 30d, 1y)
- **Default**: 30d
- **Type**: String

### victorialogs.memory_limit
- **Description**: Memory limit for VictoriaLogs container
- **Default**: 2G
- **Type**: String

### victorialogs.log_level
- **Description**: Log level (INFO, WARN, ERROR, FATAL, PANIC)
- **Default**: INFO
- **Type**: String

### victorialogs.http_auth_username
- **Description**: HTTP basic auth username (optional)
- **Default**: ""
- **Type**: String

### victorialogs.http_auth_password
- **Description**: HTTP basic auth password (optional)
- **Default**: ""
- **Type**: String

### victorialogs.max_concurrent_inserts
- **Description**: Maximum number of concurrent insert requests
- **Default**: 32
- **Type**: Integer

### victorialogs.insert_rate_limit
- **Description**: Per-second limit on inserted log entries (0 = unlimited)
- **Default**: 0
- **Type**: Integer

## Docker Configuration

### docker.storage_driver
- **Description**: Docker storage driver
- **Default**: overlay2
- **Type**: String

### docker.data_root
- **Description**: Root directory of persistent Docker state
- **Default**: /var/vcap/data/docker
- **Type**: String

## Monitoring Configuration

### monitoring.enabled
- **Description**: Enable monitoring exporters
- **Default**: true
- **Type**: Boolean

### monitoring.node_exporter_port
- **Description**: Port for node exporter
- **Default**: 9100
- **Type**: Integer

### monitoring.docker_exporter_port
- **Description**: Port for Docker exporter
- **Default**: 9323
- **Type**: Integer

### monitoring.scrape_interval
- **Description**: Metrics scrape interval
- **Default**: 30s
- **Type**: String

### monitoring.retention_days
- **Description**: Metrics retention period in days
- **Default**: 7
- **Type**: Integer

## VictoriaLogs Cluster Configuration

The cluster deployment uses native VictoriaMetrics binaries (version v1.36.1) to provide horizontal scalability and high availability. The cluster consists of three components:
- **vlstorage**: Stores and manages data
- **vlinsert**: Handles data ingestion
- **vlselect**: Processes queries

### VLStorage Configuration

#### vlstorage.http_port
- **Description**: Port for vmstorage HTTP API
- **Default**: 8482
- **Type**: Integer

#### vlstorage.vminsert_port
- **Description**: Port for vminsert connections
- **Default**: 8400
- **Type**: Integer

#### vlstorage.vmselect_port
- **Description**: Port for vmselect connections
- **Default**: 8401
- **Type**: Integer

#### vlstorage.storage_path
- **Description**: Path for persistent storage of logs
- **Default**: /var/vcap/store/vlstorage/data
- **Type**: String

#### vlstorage.retention_period
- **Description**: Log retention period (e.g., 7d, 30d, 1y)
- **Default**: 7d
- **Type**: String

#### vlstorage.log_level
- **Description**: Log level (INFO, WARN, ERROR, FATAL, PANIC)
- **Default**: INFO
- **Type**: String

#### vlstorage.http_auth_username
- **Description**: HTTP basic auth username (optional)
- **Default**: ""
- **Type**: String

#### vlstorage.http_auth_password
- **Description**: HTTP basic auth password (optional)
- **Default**: ""
- **Type**: String

#### vlstorage.memory_allowed_percent
- **Description**: Allowed percent of system memory VictoriaMetrics caches may occupy
- **Default**: 60
- **Type**: Integer

#### vlstorage.dedup_min_scrape_interval
- **Description**: Leave only the first sample in every interval for deduplication
- **Default**: ""
- **Type**: String

### VLInsert Configuration

#### vlinsert.http_port
- **Description**: Port for vminsert HTTP API
- **Default**: 8480
- **Type**: Integer

#### vlinsert.api_endpoint
- **Description**: VictoriaMetrics insert API endpoint
- **Default**: /insert
- **Type**: String

#### vlinsert.log_level
- **Description**: Log level (INFO, WARN, ERROR, FATAL, PANIC)
- **Default**: INFO
- **Type**: String

#### vlinsert.http_auth_username
- **Description**: HTTP basic auth username (optional)
- **Default**: ""
- **Type**: String

#### vlinsert.http_auth_password
- **Description**: HTTP basic auth password (optional)
- **Default**: ""
- **Type**: String

#### vlinsert.max_concurrent_inserts
- **Description**: Maximum number of concurrent insert requests
- **Default**: 32
- **Type**: Integer

#### vlinsert.max_insert_request_size
- **Description**: Maximum size in bytes of a single Prometheus remote_write API request
- **Default**: 33554432
- **Type**: Integer

#### vlinsert.replication_factor
- **Description**: Replication factor for the ingested data
- **Default**: 1
- **Type**: Integer

#### vlinsert.disable_rerouting
- **Description**: Whether to disable re-routing when some vmstorage nodes are slow
- **Default**: false
- **Type**: Boolean

#### vlinsert.memory_allowed_percent
- **Description**: Allowed percent of system memory VictoriaMetrics caches may occupy
- **Default**: 60
- **Type**: Integer

#### vlinsert.syslog_listen_addr
- **Description**: TCP address to listen for syslog data (empty to disable)
- **Default**: ""
- **Type**: String

### VLSelect Configuration

#### vlselect.http_port
- **Description**: Port for vmselect HTTP API
- **Default**: 8481
- **Type**: Integer

#### vlselect.api_endpoint
- **Description**: VictoriaMetrics select API endpoint
- **Default**: /select
- **Type**: String

#### vlselect.log_level
- **Description**: Log level (INFO, WARN, ERROR, FATAL, PANIC)
- **Default**: INFO
- **Type**: String

#### vlselect.http_auth_username
- **Description**: HTTP basic auth username (optional)
- **Default**: ""
- **Type**: String

#### vlselect.http_auth_password
- **Description**: HTTP basic auth password (optional)
- **Default**: ""
- **Type**: String

#### vlselect.max_concurrent_requests
- **Description**: Maximum number of concurrent select requests
- **Default**: 32
- **Type**: Integer

#### vlselect.memory_allowed_percent
- **Description**: Allowed percent of system memory VictoriaMetrics caches may occupy
- **Default**: 60
- **Type**: Integer

#### vlselect.dedup_min_scrape_interval
- **Description**: Leave only the first sample in every interval for deduplication
- **Default**: ""
- **Type**: String

#### vlselect.search_max_query_duration
- **Description**: Maximum duration for query execution
- **Default**: 30s
- **Type**: String
