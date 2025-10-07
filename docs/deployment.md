# VictoriaLogs BOSH Release - Deployment Guide

This guide provides detailed instructions for deploying VictoriaLogs using BOSH.

## Prerequisites

- BOSH Director v2+ configured and running
- Ubuntu Jammy (22.04) or Noble (24.04) stemcell uploaded
- Cloud config with appropriate VM types and disk types
- Network configuration in cloud config

## VM Requirements

Minimum recommended specifications:
- **CPU**: 2 cores
- **RAM**: 4GB
- **Disk**: 50GB persistent disk
- **OS**: Ubuntu Jammy or Noble

## Deployment Steps

### 1. Upload Stemcell

```bash
bosh upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-jammy-go_agent
```

### 2. Upload Release

```bash
bosh upload-release https://github.com/fivetwenty-io/victorialogs-boshrelease/releases/download/latest/victorialogs.tgz
```

### 3. Deploy

```bash
bosh -d victorialogs deploy manifests/victorialogs.yml
```

### 4. Verify Deployment

```bash
bosh -d victorialogs instances
bosh -d victorialogs ssh victorialogs/0 'curl -s http://localhost:9428/health'
```

## Accessing VictoriaLogs

After deployment, VictoriaLogs is accessible at:
- API: `http://<instance-ip>:9428`
- Health: `http://<instance-ip>:9428/health`

## Cluster Deployment

For high-availability and horizontal scalability, deploy VictoriaLogs in cluster mode.

### Cluster Architecture

VictoriaLogs cluster consists of three components:
- **vlstorage**: Persistent storage nodes (minimum 2 for HA)
- **vlinsert**: Log ingestion nodes (minimum 2 for HA)
- **vlselect**: Query processing nodes (minimum 2 for HA)

### Cluster VM Requirements

Minimum recommended specifications per component:

**VLStorage nodes**:
- CPU: 4 cores
- RAM: 8GB
- Disk: 100GB persistent disk per node

**VLInsert nodes**:
- CPU: 2 cores
- RAM: 4GB
- Disk: 10GB

**VLSelect nodes**:
- CPU: 2 cores
- RAM: 4GB
- Disk: 10GB

### Cluster Deployment Steps

#### 1. Deploy Cluster

```bash
bosh -d victorialogs-cluster deploy manifests/victorialogs-cluster.yml
```

#### 2. Verify Cluster Deployment

```bash
# Check all instances are running
bosh -d victorialogs-cluster instances

# Verify vlstorage nodes
bosh -d victorialogs-cluster ssh vlstorage/0 'curl -s http://localhost:9491/health'
bosh -d victorialogs-cluster ssh vlstorage/1 'curl -s http://localhost:9491/health'

# Verify vlinsert nodes
bosh -d victorialogs-cluster ssh vlinsert/0 'curl -s http://localhost:9481/health'
bosh -d victorialogs-cluster ssh vlinsert/1 'curl -s http://localhost:9481/health'

# Verify vlselect nodes
bosh -d victorialogs-cluster ssh vlselect/0 'curl -s http://localhost:9471/health'
bosh -d victorialogs-cluster ssh vlselect/1 'curl -s http://localhost:9471/health'
```

### Accessing Cluster Endpoints

After deployment, interact with the cluster through:

**Log Ingestion** (via vlinsert):
```bash
# Insert logs
curl -X POST http://<vlinsert-ip>:9481/insert/jsonline \
  -H "Content-Type: application/x-ndjson" \
  -d '{"_time":"2024-01-01T12:00:00Z","level":"info","message":"Test log"}'
```

**Query Logs** (via vlselect):
```bash
# Query logs
curl "http://<vlselect-ip>:9471/select/logsql/query?query=level:info"
```

### Scaling the Cluster

To scale the cluster, update the instance counts in the manifest:

```yaml
instance_groups:
- name: vlstorage
  instances: 3  # Scale from 2 to 3

- name: vlinsert
  instances: 3  # Scale from 2 to 3

- name: vlselect
  instances: 3  # Scale from 2 to 3
```

Then redeploy:
```bash
bosh -d victorialogs-cluster deploy manifests/victorialogs-cluster.yml
```

**Note**: When scaling vlstorage, existing data will be redistributed. Plan scaling during maintenance windows.

### Cluster vs Single-Node

**Use single-node** (`victorialogs.yml`) when:
- Testing or development
- Low log volume (< 1M logs/day)
- Single availability zone acceptable

**Use cluster** (`victorialogs-cluster.yml`) when:
- Production environments
- High log volume (> 1M logs/day)
- High availability required
- Horizontal scalability needed
- Multi-AZ deployment required

## Next Steps

- See [Configuration Guide](configuration.md) for customization options
- See [Troubleshooting Guide](troubleshooting.md) for common issues
