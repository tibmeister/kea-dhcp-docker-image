# Kea DHCP Docker Image

This repository builds a Docker image for [ISC Kea DHCP](https://kea.isc.org/), version 2.4.1.

## Features
- Built from official ISC source
- MySQL backend support included
- Suitable for production use with Docker Compose or Kubernetes

## Usage
Pull the image:
```sh
docker pull ghcr.io/<your-username>/kea-dhcp:2.4.1
```

Or build manually:
```sh
docker build -t kea-dhcp:2.4.1 .
```

Run with custom config:
```sh
docker run -d \
  -v $(pwd)/kea-config:/etc/kea \
  -p 67:67/udp \
  kea-dhcp:2.4.1
```

## GitHub Actions
This project uses GitHub Actions to build and publish images to:
- GitHub Container Registry (GHCR)
- Docker Hub

Secrets required:
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

## License
Apache 2.0 or ISC License per original Kea source.