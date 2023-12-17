#!/bin/false

# For CPU specific processes
# Mamba will downgrade python to satisfy requirements. We don't want that.
python_lock=$(micromamba -n $MAMBA_DEFAULT_ENV run python -V|awk '{print $2}'|cut -d '.' -f1,2)

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
        python=${python_lock} \
        pytorch=${PYTORCH_VERSION} torchvision \
        torchaudio \
        cpuonly \
        ffmpeg="$ffmpeg_version"
    