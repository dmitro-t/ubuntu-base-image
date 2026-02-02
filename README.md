## Installing LEMP stack with Vagrant 
Initial installing Nginx server, MySQL server, PHP8.1-fpm

## Build
```bash
packer init .
packer validate .
packer build -var-file="vars.hcl" .
```

## Create Vagrant box
```bash
vagrant init vbox-ubuntu
vagrant box add vbox-ubuntu ./ubuntu.box
vagrant box list
```

## Run VM
```bash
cd .\ubuntu-lemp
vagrant up
```
