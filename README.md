## Ubuntu base image with Packer
Automated Ubuntu 22.04 image build using Packer, VirtualBox and cloud-init autoinstall

## Tech stack
- Packer
- VirtualBox
- Ubuntu Server 22.04
- cloud-init (autoinstall)
- SSH provisioning

## Features
- Fully automated installation
- cloud-init autoinstall
- SSH access via key
- Base system provisioning
- Golden Image concept

## Build
```bash
packer init .
packer validate .
packer build -var-file="vars.hcl" .
```