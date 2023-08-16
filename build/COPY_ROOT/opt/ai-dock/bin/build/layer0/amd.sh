#!/bin/bash

# Must exit and fail to build if any command fails
set -e

# For ROCm specific logic
# Pytorch for ROCm is not available through conda
# but we can still get the dependencies

# Mamba will downgrade python to satisfy requirements. We don't want that.
python_lock=$(micromamba -n $MAMBA_DEFAULT_ENV run python -V|awk '{print $2}'|cut -d '.' -f1,2)

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    -c pytorch \
    -c conda-forge \
    pytorch=${PYTORCH_VERSION} torchvision torchaudio \
    python=${python_lock} \
    --only-deps
# Now pip install...
micromamba -n $MAMBA_DEFAULT_ENV run pip install \
    --no-cache-dir \
    --index-url https://download.pytorch.org/whl/rocm${ROCM_VERSION} \
    torch==${PYTORCH_VERSION} torchvision torchaudio