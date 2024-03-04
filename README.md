[![Docker Build](https://github.com/ai-dock/pytorch/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/pytorch/actions/workflows/docker-build.yml)

# Pytorch

Run python in a container with pytorch pre-installed.

## About Pytorch

PyTorch is an open-source deep learning framework developed by Facebook's AI Research lab (FAIR). It provides a flexible and dynamic computational graph, allowing developers to build and train neural networks. Unlike some other frameworks, PyTorch enables defining and modifying network architectures on-the-fly, making experimentation and debugging easier.

One of PyTorch's essential features is automatic differentiation, which is crucial for training neural networks using gradient-based optimization algorithms like backpropagation. Additionally, PyTorch supports GPU acceleration, enabling faster computation during model training.

The framework has gained popularity among researchers and developers due to its ease of use and extensive community support. With a large and active community, users can find abundant resources, tutorials, and libraries to support their deep learning projects.

## Pre-built Images

Docker images are built automatically through a GitHub Actions workflow and hosted at the GitHub Container Registry.

An incremental build process is used to avoid needing a huge cache - The following images are used to provide functionality:

- [nvidia/cuda](https://github.com/NVIDIA/nvidia-docker) / [ubuntu](https://github.com/docker-library/docs/tree/master/ubuntu) &#8628;
- [ai-dock/base-image](https://github.com/ai-dock/base-image) &#8628;
- [ai-dock/python](https://github.com/ai-dock/python) &#8628;
- ai-dock/pytorch

#### Version Tags

The `:latest` tag points to `:latest-cuda`

Tags follow these patterns:

##### _CUDA_
- `:[pytorch-version]-py[python-version]-cuda-[x.x.x]-base-[ubuntu-version]`

- `:latest-cuda` &rarr; `:2.2.1-py3.12-cuda-12.1.0-base-22.04`

##### _ROCm_
- `:[pytorch-version]-py[python-version]-rocm-[x.x.x]-runtime-[ubuntu-version]`

- `:latest-rocm` &rarr; `:2.2.1-py3.12-rocm-5.7-runtime-22.04`

##### _CPU_
- `:[pytorch-version]-py[python-version]-ubuntu-[ubuntu-version]`

- `:latest-cpu` &rarr; `:2.2.1-py3.12-cpu-22.04` 

Browse [here](https://github.com/ai-dock/pytorch/pkgs/container/pytorch) for an image suitable for your target environment.

You can also self-build from source by editing `.env` and running `docker compose build`.

Supported Python versions: `3.12`, `3.11`, `3.10`

Supported Pytorch versions: `2.2.1` `2.1.2`

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`

## Building Images

You can self-build from source by editing `docker-compose.yaml` or `.env` and running `docker compose build`.

It is a good idea to leave the source tree alone and copy any edits you would like to make into `build/COPY_ROOT_EXTRA/...`. The structure within this directory will be overlayed on `/` at the end of the build process.

As this overlaying happens after the main build, it is easy to add extra files such as ML models and datasets to your images. You will also be able to rebuild quickly if your file overrides are made here.

Any directories and files that you add into `opt/storage` will be made available in the running container at `$WORKSPACE/storage`.  

This directory is monitored by `inotifywait`. Any items appearing in this directory will be automatically linked to the application directories as defined in `/opt/ai-dock/storage_monitor/etc/mappings.sh`.  This is particularly useful if you need to run several applications that each need to make use of the stored files.


## Run Locally

A 'feature-complete' `docker-compose.yaml` file is included for your convenience. All features of the image are included - Simply edit the environment variables in `.env`, save and then type `docker compose up`.

If you prefer to use the standard `docker run` syntax, the command to pass is `init.sh`.

## Run in the Cloud

This image should be compatible with any GPU cloud platform. You simply need to pass environment variables at runtime. 

>[!NOTE]  
>Please raise an issue on this repository if your provider cannot run the image.

__Container Cloud__

Container providers don't give you access to the docker host but are quick and easy to set up. They are often inexpensive when compared to a full VM or bare metal solution.

All images built for ai-dock are tested for compatibility with both [vast.ai](https://link.ai-dock.org/template-vast-pytorch) and [runpod.io](https://link.ai-dock.org/template-runpod-pytorch).

See a list of pre-configured templates [here](#pre-configured-templates)

>[!WARNING]  
>Container cloud providers may offer both 'community' and 'secure' versions of their cloud. If your usecase involves storing sensitive information (eg. API keys, auth tokens) then you should always choose the secure option.

__VM Cloud__

Running docker images on a virtual machine/bare metal server is much like running locally.

You'll need to:
- Configure your server
- Set up docker
- Clone this repository
- Edit `.env`and `docker-compose.yml`
- Run `docker compose up`

Find a list of compatible VM providers [here](#compatible-vm-providers).

### Connecting to Your Instance

All services listen for connections at [`0.0.0.0`](https://en.m.wikipedia.org/wiki/0.0.0.0). This gives you some flexibility in how you interact with your instance:

_**Expose the Ports**_

This is fine if you are working locally but can be **dangerous for remote connections** where data is passed in plaintext between your machine and the container over http.

_**SSH Tunnel**_

You will only need to expose port `22` (SSH) which can then be used with port forwarding to allow **secure** connections to your services.

If you are unfamiliar with port forwarding then you should read the guides [here](https://link.ai-dock.org/guide-ssh-tunnel-do-a) and [here](https://link.ai-dock.org/guide-ssh-tunnel-do-b).

_**Cloudflare Tunnel**_

You can use the included `cloudflared` service to make secure connections without having to expose any ports to the public internet. See more below.

## Environment Variables

| Variable                 | Description |
| ------------------------ | ----------- |
| `CF_TUNNEL_TOKEN`        | Cloudflare zero trust tunnel token - See [documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/). |
| `CF_QUICK_TUNNELS`       | Create ephemeral Cloudflare tunnels for web services (default `false`) |
| `DIRECT_ADDRESS`         | IP/hostname for service portal direct links (default `localhost`) |
| `DIRECT_ADDRESS_GET_WAN` | Use the internet facing interface for direct links (default `false`) |
| `GPU_COUNT`              | Limit the number of available GPUs |
| `PROVISIONING_SCRIPT`    | URL of a remote script to execute on init. See [note](#provisioning-script). |
| `RCLONE_*`               | Rclone configuration - See [rclone documentation](https://rclone.org/docs/#config-file) |
| `SKIP_ACL`               | Set `true` to skip modifying workspace ACL |
| `SSH_PORT_LOCAL`         | Set a non-standard port for SSH (default `22`) |
| `SSH_PUBKEY`             | Your public key for SSH |
| `USER_NAME`              | System account username (default `user`)|
| `USER_PASSWORD`          | System account username (default `password`)|
| `WEB_ENABLE_AUTH`        | Enable password protection for web services (default `true`) |
| `WEB_USER`               | Username for web services (default `user`) |
| `WEB_PASSWORD`           | Password for web services (default `auto generated`) |
| `WORKSPACE`              | A volume path. Defaults to `/workspace/` |
| `WORKSPACE_SYNC`         | Move mamba environments and services to workspace if mounted (default `false`) |

Environment variables can be specified by using any of the standard methods (`docker-compose.yaml`, `docker run -e...`). Additionally, environment variables can also be passed as parameters of `init.sh`.

Passing environment variables to init.sh is usually unnecessary, but is useful for some cloud environments where the full `docker run` command cannot be specified.

Example usage: `docker run -e STANDARD_VAR1="this value" -e STANDARD_VAR2="that value" init.sh EXTRA_VAR="other value"`

## Security

All ai-dock containers are interactive and will not drop root privileges. You should ensure that your docker daemon runs as an unprivileged user.

### System

A system user will be created at startup. The UID will be either 1000 or will match the UID of the `$WORKSPACE` bind mount.

The user will share the root user's ssh public key.

Some processes may start in the user context for convenience only.

### Web Services

By default, all exposed web services are protected by a single login form at `:1111/login`.

The default username is `user` and the password is auto generated unless you have passed a value in the environment variable `WEB_PASSWORD`. To find the auto-generated password and related tokens you should type `env | grep WEB_` from inside the container.

You can set your credentials by passing environment variables as shown above.

If you are running the image locally on a trusted network, you may disable authentication by setting the environment variable `WEB_ENABLE_AUTH=false`.

If you need to connect programmatically to the web services you can authenticate using either `Bearer $WEB_TOKEN` or `Basic $WEB_PASSWORD_B64`.

The security measures included aim to be as secure as basic authentication, i.e. not secure without HTTPS.  Please use the provided cloudflare connections wherever possible.

>[!NOTE]  
>You can use `set-web-credentials.sh <username> <password>` to change the username and password in a running container.

## Provisioning script

It can be useful to perform certain actions when starting a container, such as creating directories and downloading files.

You can use the environment variable `PROVISIONING_SCRIPT` to specify the URL of a script you'd like to run.

The URL must point to a plain text file - GitHub Gists/Pastebin (raw) are suitable options.

If you are running locally you may instead opt to mount a script at `/opt/ai-dock/bin/provisioning.sh`.

>[!NOTE]  
>If configured, `sshd`, `caddy`, `cloudflared`, `serviceportal`, `storagemonitor` & `logtail` will be launched before provisioning; Any other processes will launch after.

>[!WARNING]  
>Only use scripts that you trust and which cannot be changed without your consent.

## Software Management

A small software collection is installed by apt-get to provide basic utility.

All other software is installed into its own environment by `micromamba`, which is a drop-in replacement for conda/mamba. Read more about it [here](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html).

Micromamba environments are particularly useful where several software packages are required but their dependencies conflict. 

### Installed Micromamba Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `base`         | micromamba's base environment |
| `python_[ver]` | `python` |

If you are extending this image or running an interactive session where additional software is required, you should almost certainly create a new environment first. See below for guidance.

### Useful Micromamba Commands

| Command                              | Function |
| -------------------------------------| --------------------- |
| `micromamba env list`                | List available environments |
| `micromamba activate [name]`         | Activate the named environment |
| `micromamba deactivate`              | Close the active environment |
| `micromamba run -n [name] [command]` | Run a command in the named environment without activating |

All ai-dock images create micromamba environments using the `--always-softlink` flag which can save disk space where multiple environments are available.

To create an additional micromamba environment, eg for python, you can use the following:

`micromamba --always-softlink create -y -c conda-forge -c defaults -n [name] python=3.10`

## Volumes

Data inside docker containers is ephemeral - You'll lose all of it when the container is destroyed.

You may opt to mount a data volume at `/workspace` - This is a directory that ai-dock images will look for to make downloaded data available outside of the container for persistence. 

This is usually of importance where large files are downloaded at runtime or if you need a space to save your work. This is the ideal location to store any code you are working on.

You can define an alternative path for the workspace directory by passing the environment variable `WORKSPACE=/my/alternative/path/` and mounting your volume there. This feature will generally assist where cloud providers enforce their own mountpoint location for persistent storage.

The provided docker-compose.yaml will mount the local directory `./workspace` at `/workspace`.

As docker containers generally run as the root user, new files created in /workspace will be owned by uid 0(root).

To ensure that the files remain accessible to the local user that owns the directory, the docker entrypoint will set a default ACL on the directory by executing the commamd `setfacl -d -m u:${WORKSPACE_UID}:rwx /workspace`.

## Running Services

This image will spawn multiple processes upon starting a container because some of our remote environments do not support more than one container per instance.

All processes are managed by [supervisord](https://supervisord.readthedocs.io/en/latest/) and will restart upon failure until you either manually stop them or terminate the container.

>[!NOTE]  
>*Some of the included services would not normally be found **inside** of a container. They are, however, necessary here as some cloud providers give no access to the host; Containers are deployed as if they were a virtual machine.*

### Caddy

This is a simple webserver acting as a reverse proxy.

Caddy is used to enable basic authentication for all sensitive web services.

To make changes to the caddy configuration inside a runing container you should edit `/opt/caddy/share/base_config` followed by `supervisorctl restart caddy`.

### Service Portal

This is a simple list of links to the web services available inside the container.

The service will bind to port `1111`.

For each service, you will find a direct link and, if you have set `CF_QUICK_TUNNELS=true`, a link to the service via a fast and secure Cloudflare tunnel.

A simple web-based log viewer and process manager are included for convenience.

### Cloudflared

The Cloudflare tunnel daemon will start if you have provided a token with the `CF_TUNNEL_TOKEN` environment variable.

This service allows you to connect to your local services via https without exposing any ports.

You can also create a private network to enable remote connecions to the container at its local address (`172.x.x.x`) if your local machine is running a Cloudflare WARP client.

If you do not wish to provide a tunnel token, you could enable `CF_QUICK_TUNNELS` which will create a throwaway tunnel for your web services.

Full documentation for Cloudflare tunnels is [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/).

>[!NOTE]  
>_Cloudflared is included so that secure networking is available in all cloud environments._

>[!WARNING]  
>You should only provide tunnel tokens in secure cloud environments.

### SSHD

A SSH server will be started if at least one valid public key is found inside the running container in the file `/root/.ssh/authorized_keys`

The server will bind to port `22` unless you specify variable `SSH_PORT`.

There are several ways to get your keys to the container.

- If using docker compose, you can paste your key in the local file `config/authorized_keys` before starting the container.
 
- You can pass the environment variable `SSH_PUBKEY` with your public key as the value.

- Cloud providers often have a built-in method to transfer your key into the container

If you choose not to provide a public key then the SSH server will not be started.

To make use of this service you should map port `22` to a port of your choice on the host operating system.

See [this guide](https://link.ai-dock.org/guide-sshd-do) by DigitalOcean for an excellent introduction to working with SSH servers.

>[!NOTE]  
>_SSHD is included because the end-user should be able to know the version prior to deloyment. Using a providers add-on, if available, does not guarantee this._

### Logtail

This script follows and prints the log files for each of the above services to stdout. This allows you to follow the progress of all running services through docker's own logging system.

If you are logged into the container you can follow the logs by running `logtail.sh` in your shell.

### Storage Monitor

This service detects changes to files in `$WORKSPACE/storage` and creates symbolic links to the application directories defined in `/opt/ai-dock/storage_monitor/etc/mappings.sh`

## Open Ports

Some ports need to be exposed for the services to run or for certain features of the provided software to function


| Open Port             | Service / Description     |
| --------------------- | ------------------------- |
| `22`                  | SSH server                |
| `1111`                | Service Portal web UI     |
| `53682`               | Rclone interactive config |

## Pre-Configured Templates

**Vast.​ai**

[pytorch:latest](https://link.ai-dock.org/template-vast-pytorch)

**Runpod.​io**

[pytorch:latest](https://link.ai-dock.org/template-runpod-pytorch)

>[!NOTE]  
>These templates are configured to use the `:latest` tag but you are free to change to any of the available Pytorch CUDA tags listed [here](https://github.com/ai-dock/pytorch/pkgs/container/pytorch)

## Compatible VM Providers

Images that do not require a GPU will run anywhere - Use an image tagged `:*-cpu-xx.xx`

Where a GPU is required you will need either `:*cuda*` or `:*rocm*` depending on the underlying hardware.

A curated list of VM providers currently offering GPU instances:

- [Akami/Linode](https://link.ai-dock.org/linode.com)
- [Amazon Web Services](https://link.ai-dock.org/aws.amazon.com)
- [Google Compute Engine](https://link.ai-dock.org/cloud.google.com)
- [Vultr](https://link.ai-dock.org/vultr.com)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs_