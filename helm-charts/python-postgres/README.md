# Python-Postgres App

## Overview

The `python-postgres` app is a simple Flask-based application that connects to a PostgreSQL database. It provides the following features:

1. **Database Creation**: If the specified database does not exist, it attempts to create it.
2. **Connection Verification**: Checks if the app can successfully connect to the PostgreSQL database.
3. **Endpoint**: Exposes a single endpoint (`/`) that returns a message indicating whether the connection to the PostgreSQL database was successful.

## Prerequisites

- Docker
- Kubernetes cluster with Helm and NGINX Ingress installed

## Deployment Instructions

1. **Build the Docker Image**:

```bash
docker build -t python-postgres:latest -f dockerfiles/python-postgres/Dockerfile .

docker push <your-registry>/python-postgres:latest

helm install python-postgres ./path-to-helm-chart

curl -H "Host: python-postgres" <INGRESS-IP>
```
