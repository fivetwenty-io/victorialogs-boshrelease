# VictoriaLogs Configuration Guide

This guide details all configuration options available in the VictoriaLogs BOSH release.

## VictoriaLogs Configuration

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

### VLStorage Configuration

#### vlstorage.port
- **Description**: Port for VLStorage HTTP API
- **Default**: 9491
- **Type**: Integer

#### vlstorage.internal_port
- **Description**: Internal port for vlinsert/vlselect communication
- **Default**: 9491
- **Type**: Integer

#### vlstorage.container_image
- **Description**: Docker image for VLStorage component
- **Default**: docker.io/victoriametrics/victoria-logs:v1.35.0
- **Type**: String

#### vlstorage.storage_path
- **Description**: Path for persistent storage of logs
- **Default**: /var/vcap/store/vlstorage/data
- **Type**: String

#### vlstorage.retention_period
- **Description**: Log retention period (e.g., 7d, 30d, 1y)
- **Default**: 7d
- **Type**: String

#### vlstorage.memory_limit
- **Description**: Memory limit for VLStorage container
- **Default**: 4G
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

### VLInsert Configuration

#### vlinsert.port
- **Description**: Port for VLInsert HTTP API
- **Default**: 9481
- **Type**: Integer

#### vlinsert.api_endpoint
- **Description**: VLInsert API endpoint
- **Default**: /insert
- **Type**: String

#### vlinsert.container_image
- **Description**: Docker image for VLInsert component
- **Default**: docker.io/victoriametrics/victoria-logs:v1.35.0
- **Type**: String

#### vlinsert.memory_limit
- **Description**: Memory limit for VLInsert container
- **Default**: 2G
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

#### vlinsert.insert_rate_limit
- **Description**: Per-second limit on inserted log entries (0 = unlimited)
- **Default**: 0
- **Type**: Integer

### VLSelect Configuration

#### vlselect.port
- **Description**: Port for VLSelect HTTP API
- **Default**: 9471
- **Type**: Integer

#### vlselect.api_endpoint
- **Description**: VLSelect API endpoint
- **Default**: /select
- **Type**: String

#### vlselect.container_image
- **Description**: Docker image for VLSelect component
- **Default**: docker.io/victoriametrics/victoria-logs:v1.35.0
- **Type**: String

#### vlselect.memory_limit
- **Description**: Memory limit for VLSelect container
- **Default**: 2G
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
