# ansible-homelab

This repository contains an Ansible-based setup for deploying a Kubernetes
cluster and installing Argo CD with predefined applications.

## Features

- Deployment and maintenance of a Kubernetes cluster
- Automated certificate handling using [Let's Encrypt](https://letsencrypt.org/)
(domain at [STRATO](https://www.strato.de/) necessary)
- Installation of [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)
- Installation of [Argo CD](https://argoproj.github.io/cd/)
- Deployment of applications definied in [argocd-homelab](https://github.com/kymzky/argocd-homelab)

## Usage

The recommended approach for using this repository is to install [Task](https://taskfile.dev/)
and use the provided [Taskfile.yaml](./Taskfile.yaml). For the playbooks to
work, you need to create a `.vault-pass` file and use it to regenerate the
encrypted variables (see [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html)).
