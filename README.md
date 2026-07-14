# boxsetup

This repository provides a minimal Vagrant-based VM setup for building OpenClaw.

## Requirements

- Vagrant
- VirtualBox

## Usage

From this repository root:

```bash
vagrant up
```

The VM provisioning script will:

1. Install build dependencies.
2. Clone `https://github.com/opentheclaw/openclaw.git` into `/home/vagrant/openclaw`.
3. Configure and build OpenClaw in `/home/vagrant/openclaw/build`.

To access the VM:

```bash
vagrant ssh
```
