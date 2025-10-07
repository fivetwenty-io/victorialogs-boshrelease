# BOSH Release Blob Update Scripts

This directory contains utility scripts for managing BOSH release blobs.

## scripts/blobs

A Perl script that automatically updates blobs to their latest versions.

### Prerequisites

- Perl 5.14+ (HTTP::Tiny module required, included in Perl core)
- `bosh` CLI tool in PATH
- Internet connection to fetch latest versions

### Usage

```bash
# Update all blobs (docker-ce)
./scripts/blobs all

# Update only Docker CE blobs
./scripts/blobs docker-ce

# Dry run mode - show what would be updated without making changes
./scripts/blobs docker-ce --dry-run
./scripts/blobs all --dry-run
```

### What it does

**For Docker CE (`docker-ce`):**
- Fetches latest package versions from Docker's Ubuntu repositories
- Updates packages for both Ubuntu 22.04 (Jammy) and 24.04 (Noble):
  - `containerd.io` (common to both distributions)
  - `docker-ce`
  - `docker-ce-cli`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
- Downloads packages and updates blobstore using `bosh remove-blob` and `bosh add-blob`

### Safety Features

- **Dry-run mode**: Use `--dry-run` to preview changes without making them
- **Validation**: Checks for BOSH release directory and `bosh` CLI availability
- **Error handling**: Stops on download failures or command errors
- **Logging**: Detailed output showing what's being updated

### Examples

```bash
# See what would be updated
./scripts/blobs all --dry-run

# Update just Docker CE packages
./scripts/blobs docker-ce

# Update everything
./scripts/blobs all
```

After running, check the results with:
```bash
bosh blobs
```

### Notes

- The script uses only Perl standard library modules (no external dependencies)
- Downloads are performed to temporary directories and cleaned up automatically
- Original blobs are removed before adding new ones to avoid duplicates
- Version comparison attempts to find the latest semantic versions available
