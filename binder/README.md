# Running CRAM on BinderHub with XPRA remote desktop

## Quick Start

### Option 1: Run Image Locally (Under repo directory)

- Run and Build Docker image

  ```bash
  docker compose -f ./binder/docker-compose.yml up
  ```

- Open Web browser and go to http://localhost:8888/

- Force rebuilding image

  ```bash
  docker compose -f ./binder/docker-compose.yml up -d --build
  ```

### Option 2: Run on BinderHub

- Link to the binderhub: https://binder.intel4coro.de/v2/gh/IntEL4CoRo/cram_teaching.git/main-xpra

## Usage

## Files Descriptions

1. ***[Dockerfile](./Dockerfile):*** A Jupyterlab Docker image with cram installed.
1. ***[entrypoint.sh](./entrypoint.sh):*** Entrypoint of the docker image, start roscore and visualization tools.
1. ***[cram.jupyterlab-workspace](./cram.jupyterlab-workspace):*** Custom JupyterLab workspace.
1. ***[docker-compose.yml](./docker-compose.yml):*** For testing the docker image locally.
