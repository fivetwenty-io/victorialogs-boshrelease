# VictoriaLogs BOSH Release

A BOSH release for deploying VictoriaLogs, a fast and cost-effective log management and analytics system.

## Features

- **High Performance**: Efficient log ingestion and querying
- **LogsQL Support**: Powerful query language for log analysis
- **Native Binaries**: Runs VictoriaLogs directly using native binaries for optimal performance
- **Cluster Mode**: Full support for distributed cluster deployments with vlstorage, vlinsert, and vlselect components
- **Monitoring**: Built-in Prometheus exporters for system metrics
- **Scalability**: Support for both single-node and distributed deployments
- **Flexible Storage**: Configurable retention periods and storage paths

## Components

- **VictoriaLogs**: Log management and analytics engine (victoria-logs-prod binary)
- **VLUtils**: VictoriaLogs utilities for log processing and management
- **Monitoring Stack**: Prometheus exporters for system metrics

## Quick Start

### Single-Node Deployment

1. **Upload the release:**
```bash
bosh upload-release https://github.com/fivetwenty-io/victorialogs-boshrelease/releases/download/latest/victorialogs.tgz
```

2. **Deploy:**
```bash
bosh -d victorialogs deploy manifests/victorialogs.yml
```

3. **Access the services:**
- VictoriaLogs API: `http://<instance-ip>:9428`
- Insert logs: `POST http://<instance-ip>:9428/insert/jsonline`
- Query logs: `GET http://<instance-ip>:9428/select/logsql/query?query=<query>`

### Cluster Deployment

1. **Upload the release** (same as single-node)

2. **Deploy cluster:**
```bash
bosh -d victorialogs-cluster deploy manifests/victorialogs-cluster.yml
```

3. **Access the cluster:**
- VLStorage nodes: `http://<vlstorage-ip>:9491` (internal API)
- Insert logs via VLInsert: `POST http://<vlinsert-ip>:9481/insert/jsonline`
- Query logs via VLSelect: `GET http://<vlselect-ip>:9471/select/logsql/query?query=<query>`
- Health check: `GET http://<component-ip>:<port>/health`

See [Deployment Guide](docs/deployment.md) for detailed cluster deployment instructions.

## Requirements

- BOSH Director v2+
- Ubuntu Jammy or Noble stemcell
- Minimum 4GB RAM and 50GB disk

## Documentation

- [Deployment Guide](docs/deployment.md) - Detailed deployment instructions
- [Configuration Guide](docs/configuration.md) - All configuration options
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions
- [VictoriaLogs Documentation](https://docs.victoriametrics.com/victorialogs)

## Architecture

### Single-Node Deployment

```
┌───────────────────────────────────────┐
│          BOSH Director                │
└───────────────────────────────────────┘
                    │
┌───────────────────────────────────────┐
│       VictoriaLogs Instance           │
├───────────────────────────────────────┤
│  ┌────────────┐  ┌─────────────────┐  │
│  │   Docker   │  │  VictoriaLogs   │  │
│  │            │  │  (Port 9428)    │  │
│  └────────────┘  └─────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │      Monitoring Stack           │  │
│  │  (Node, Docker Exporters)       │  │
│  └─────────────────────────────────┘  │
└───────────────────────────────────────┘
```

### Cluster Deployment

```
┌──────────────────────────────────────────────────────────┐
│                    BOSH Director                         │
└──────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼────────┐  ┌──────▼───────┐  ┌──────▼───────┐
│   VLStorage    │  │   VLInsert   │  │   VLSelect   │
│   (2+ nodes)   │  │  (2+ nodes)  │  │  (2+ nodes)  │
├────────────────┤  ├──────────────┤  ├──────────────┤
│ ┌────────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │
│ │   Docker   │ │  │ │  Docker  │ │  │ │  Docker  │ │
│ └────────────┘ │  │ └──────────┘ │  │ └──────────┘ │
│ ┌────────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │
│ │ VLStorage  │ │  │ │ VLInsert │ │  │ │ VLSelect │ │
│ │ Port 9491  │◄─┼──┤ Port 9481│  │  │ Port 9471│◄─┤
│ └────────────┘ │  │ └──────────┘ │  │ └──────────┘ │
│                │  │      │       │  │      ▲       │
│ Persistent     │  │      │       │  │      │       │
│ Storage        │  │      └───────┼──┼──────┘       │
└────────────────┘  └──────────────┘  └──────────────┘
      ▲                    │                 ▲
      │                    │                 │
      └────────────────────┴─────────────────┘
            Queries log data
```

**Cluster Components:**
- **VLInsert**: Receives and distributes logs across storage nodes
- **VLSelect**: Queries storage nodes and aggregates results
- **VLStorage**: Stores log data persistently

## Development

### Building from Source

```bash
# Clone repository
git clone https://github.com/fivetwenty-io/victorialogs-boshrelease.git
cd victorialogs-boshrelease

# Create dev release
make dev-release

# Upload to director
bosh upload-release victorialogs-boshrelease.tgz

# Deploy
bosh -d victorialogs deploy manifests/victorialogs.yml
```

## API Usage

VictoriaLogs provides a LogsQL API for log ingestion and querying:

```bash
# Insert logs (JSON Lines format)
curl -X POST http://<instance-ip>:9428/insert/jsonline \
  -H "Content-Type: application/x-ndjson" \
  -d '{"_time":"2024-01-01T12:00:00Z","level":"info","message":"Application started"}'

# Query logs
curl "http://<instance-ip>:9428/select/logsql/query?query=level:error"

# Query with time range
curl "http://<instance-ip>:9428/select/logsql/query?query=*&start=2024-01-01T00:00:00Z&end=2024-01-02T00:00:00Z"
```

## Monitoring

Access metrics at:
- System metrics: `http://<instance-ip>:9100/metrics`
- Container metrics: `http://<instance-ip>:9323/metrics`

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) file for details

## Support

For issues and questions:
- GitHub Issues: https://github.com/fivetwenty-io/victorialogs-boshrelease/issues
- Documentation: See `/docs` directory

## Acknowledgments

- [VictoriaMetrics](https://victoriametrics.com) - VictoriaLogs engine
- [VictoriaLogs Documentation](https://docs.victoriametrics.com/victorialogs)
