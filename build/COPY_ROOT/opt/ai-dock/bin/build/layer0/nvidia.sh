#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail

cuda_short_version=$(cut -d '.' -f 1,2 <<< "${CUDA_VERSION}")
# Mamba will downgrade python to satisfy requirements. We don't want that.
python_lock=$(micromamba -n $MAMBA_DEFAULT_ENV run python -V|awk '{print $2}'|cut -d '.' -f1,2)

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    -c pytorch \
    -c nvidia \
    -c defaults \
    pytorch=${PYTORCH_VERSION} torchvision torchaudio \
    python=${python_lock} \
    pytorch-cuda=${cuda_short_version}
