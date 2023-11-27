# For build automation - Allows building from any ai-dock base image
# Use a *cuda*base* image as default because pytorch brings the libs
ARG IMAGE_BASE="ghcr.io/ai-dock/python:3.10-cuda-11.8.0-base-22.04"
FROM ${IMAGE_BASE}

LABEL org.opencontainers.image.source https://github.com/ai-dock/pytorch

LABEL org.opencontainers.image.description "Python with pytorch pre-installed"

LABEL maintainer="Rob Ballantyne <rob@dynamedia.uk>"

ENV IMAGE_SLUG="pytorch"
# Note: the default mamba environment is set by ai-dock/python

# Add new paths at front 
#ENV PATH=/opt/another/bin:$PATH

# Copy early so we can use scripts in the build - Changes to these files will invalidate the cache and cause a rebuild.
COPY ./COPY_ROOT/ /

# Use build scripts to ensure we can build all targets from one Dockerfile in a single layer.
# Don't put anything heavy in here - We can use multi-stage building above if necessary.
ARG PYTORCH_VERSION
ENV PYTORCH_VERSION=${PYTORCH_VERSION}
RUN /opt/ai-dock/bin/build/layer0/init.sh | tee /var/log/build.log

# Copy overrides and new files into a final layer for fast rebuilds
COPY ./COPY_ROOT_EXTRA/ /

# Keep init.sh as-is and place additional logic in /opt/ai-dock/bin/preflight.sh
CMD ["init.sh"]
