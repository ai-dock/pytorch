#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail
umask 002

source /opt/ai-dock/etc/environment.sh
source /opt/ai-dock/bin/build/layer0/common.sh

PYTHON_VENV="$VENV_DIR/$PYTHON_DEFAULT_VENV"
PYTHON_VENV_PYTHON="$PYTHON_VENV/bin/python"
PYTHON_VENV_PIP="$PYTHON_VENV/bin/pip"

if [[ "$XPU_TARGET" == "NVIDIA_GPU" ]]; then
    source /opt/ai-dock/bin/build/layer0/nvidia.sh
elif [[ "$XPU_TARGET" == "AMD_GPU" ]]; then
    source /opt/ai-dock/bin/build/layer0/amd.sh
elif [[ "$XPU_TARGET" == "CPU" ]]; then
    source /opt/ai-dock/bin/build/layer0/cpu.sh
else
    printf "No valid XPU_TARGET specified\n" >&2
    exit 1
fi

source /opt/ai-dock/bin/build/layer0/clean.sh
