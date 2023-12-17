#!/bin/false

export MAMBA_CREATE="micromamba create --always-softlink -y -c pytorch -c nvidia -c conda-forge"
export MAMBA_INSTALL="micromamba install --always-softlink -y -c pytorch -c nvidia -c conda-forge"
printf "export MAMBA_CREATE=\"%s\"\n" "${MAMBA_CREATE}" >> /opt/ai-dock/etc/environment.sh
printf "export MAMBA_INSTALL=\"%s\"\n" "${MAMBA_INSTALL}" >> /opt/ai-dock/etc/environment.sh

cuda_short_version=$(cut -d '.' -f 1,2 <<< "${CUDA_VERSION}")
# Mamba will downgrade python to satisfy requirements. We don't want that.
python_lock=$(micromamba -n $MAMBA_DEFAULT_ENV run python -V|awk '{print $2}'|cut -d '.' -f1,2)

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    pytorch=${PYTORCH_VERSION} torchvision torchaudio \
    python=${python_lock} \
    pytorch-cuda=${cuda_short_version} \
    ffmpeg="$ffmpeg_version"
