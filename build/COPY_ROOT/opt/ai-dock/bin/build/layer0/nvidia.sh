#!/bin/false

export MAMBA_CREATE="micromamba create --always-softlink -y -c pytorch -c nvidia -c conda-forge"
env-store MAMBA_CREATE
export MAMBA_INSTALL="micromamba install --always-softlink -y -c pytorch -c nvidia -c conda-forge"
env-store MAMBA_INSTALL

# Mamba will downgrade python to satisfy requirements. We don't want that.
python_lock="$(micromamba -n $MAMBA_DEFAULT_ENV run python -V | tail -n1 | awk '{print $2}' | cut -d '.' -f1,2)"

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    pytorch=${PYTORCH_VERSION} torchvision torchaudio \
    python=${python_lock} \
    pytorch-cuda="$(cut -d '.' -f 1,2 <<< "${CUDA_VERSION}")"
