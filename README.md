[![Docker Build](https://github.com/ai-dock/pytorch/actions/workflows/docker-build.yml/badge.svg)](https://github.com/ai-dock/pytorch/actions/workflows/docker-build.yml)

# AI-Dock + PyTorch

Run python in a cloud-first AI-Dock container with PyTorch pre-installed.

This image provides a great starting point for python development when used standalone but its also a solid foundation for extending upon.

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) and [runpod.io](https://link.ai-dock.org/template) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.


#### Version Tags

The `:latest` tag points to `:latest-cuda`

Tags follow these patterns:

##### _CUDA_
- `:[pytorch-version]-py[python-version]-cuda-[x.x.x]-base-[ubuntu-version]`

- `:latest-cuda` &rarr; `:2.2.1-py3.10-cuda-11.8.0-base-22.04`

##### _ROCm_
- `:[pytorch-version]-py[python-version]-rocm-[x.x.x]-runtime-[ubuntu-version]`

- `:latest-rocm` &rarr; `:2.2.1-py3.10-rocm-5.7-runtime-22.04`

##### _CPU_
- `:[pytorch-version]-py[python-version]-ubuntu-[ubuntu-version]`

- `:latest-cpu` &rarr; `:2.2.1-py3.10-cpu-22.04` 

Browse [here](https://github.com/ai-dock/pytorch/pkgs/container/pytorch) for an image suitable for your target environment.

Supported Python versions: `3.12`, `3.11`, `3.10`

Supported Pytorch versions: `2.2.1` `2.1.2`

Supported Platforms: `NVIDIA CUDA`, `AMD ROCm`, `CPU`


## Pre-Configured Templates

**Vast.​ai**

[pytorch:latest-cuda](https://link.ai-dock.org/template-vast-pytorch) (CUDA)

[pytorch:latest-rocm](https://link.ai-dock.org/template-vast-pytorch-rocm) (ROCm)

**Runpod.​io**

[pytorch:latest](https://link.ai-dock.org/template-runpod-pytorch)

>[!NOTE]  
>These templates are configured to use the `:latest` tag but you are free to change to any of the available Pytorch CUDA tags listed [here](https://github.com/ai-dock/pytorch/pkgs/container/pytorch)

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This along with [sponsorships](https://github.com/sponsors/ai-dock) helps to offset costs and further the development of the project_