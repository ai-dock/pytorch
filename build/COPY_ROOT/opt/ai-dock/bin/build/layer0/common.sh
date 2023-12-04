#!/bin/bash

# Must exit and fail to build if any command fails
set -eo pipefail

# For logic common to cpu, cuda & rocm
$MAMBA_INSTALL -n $MAMBA_DEFAULT_ENV \
    -c pytorch \
    -c conda-forge \
        ffmpeg">=4.3.1"

exit 0