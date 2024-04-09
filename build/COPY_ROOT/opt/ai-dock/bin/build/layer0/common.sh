#!/bin/false

# For logic common to cpu, cuda & rocm

source /opt/ai-dock/etc/environment.sh

if [[ $PYTORCH_VERSION == "2.0.1" ]]; then
    ffmpeg_version="4.4"
else
    ffmpeg_version="6.*"
fi

export MAMBA_CREATE="micromamba create --always-softlink -y -c pytorch -c conda-forge"
export MAMBA_INSTALL="micromamba install --always-softlink -y -c pytorch -c conda-forge"
printf "export MAMBA_CREATE=\"%s\"\n" "${MAMBA_CREATE}" >> /opt/ai-dock/etc/environment.sh
printf "export MAMBA_INSTALL=\"%s\"\n" "${MAMBA_INSTALL}" >> /opt/ai-dock/etc/environment.sh

python_version="$(micromamba -n $MAMBA_DEFAULT_ENV run python -V | tail -n1 | awk '{print $2}' | cut -d '.' -f1,2)"
printf "/opt/micromamba/envs/%s/lib/python%s/site-packages/torch/lib/\n" "$MAMBA_DEFAULT_ENV" "$python_version" >> /etc/ld.so.conf.d/x86_64-linux-gnu.micromamba.80-pytorch.conf

$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    ffmpeg="$ffmpeg_version" \
    sox=14.4.2 \
    ocl-icd-system