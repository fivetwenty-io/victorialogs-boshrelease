# VictoriaLogs Troubleshooting Guide

This guide helps diagnose and resolve common issues with VictoriaLogs BOSH deployment.

## Common Issues

### VictoriaLogs Container Not Starting

**Symptoms**: Container fails to start or immediately exits

**Diagnosis**:
```bash
bosh -d victorialogs ssh victorialogs/0
sudo su -
docker ps -a
docker logs victorialogs
```

**Solutions**:
- Check Docker daemon is running: `systemctl status docker`
- Verify image can be pulled: `docker pull victoriametrics/victoria-logs:v1.35.0`
- Check disk space: `df -h`
- Review container logs for specific errors

### API Not Responding

**Symptoms**: Cannot access VictoriaLogs API at port 9428

**Diagnosis**:
```bash
bosh -d victorialogs ssh victorialogs/0
curl -v http://localhost:9428/health
docker ps | grep victorialogs
```

**Solutions**:
- Verify container is running
- Check port binding: `netstat -tulpn | grep 9428`
- Review firewall rules
- Check container logs

### High Memory Usage

**Symptoms**: Container consuming excessive memory

**Diagnosis**:
```bash
docker stats victorialogs
```

**Solutions**:
- Increase `victorialogs.memory_limit` in manifest
- Reduce `victorialogs.retention_period`
- Check for log ingestion spikes

### Docker Issues

**Symptoms**: Docker daemon not responding

**Diagnosis**:
```bash
systemctl status docker
docker info
journalctl -u docker -n 100
```

**Solutions**:
- Restart Docker: `monit restart docker`
- Check disk space
- Review Docker logs

## Getting Help

If issues persist:
1. Collect logs: `bosh -d victorialogs logs`
2. Check BOSH events: `bosh -d victorialogs events`
3. Open an issue at: https://github.com/fivetwenty-io/victorialogs-boshrelease/issues
