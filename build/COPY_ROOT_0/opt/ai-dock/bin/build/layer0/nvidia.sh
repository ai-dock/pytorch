#!/bin/false

build_nvidia_main() {
    build_nvidia_install_torch
    build_common_run_tests
    build_nvidia_run_tests
}

build_nvidia_install_torch() {
    short_cuda_version="cu$(cut -d '.' -f 1,2 <<< "${CUDA_VERSION}" | tr -d '.')"
    "$PYTHON_VENV_PIP" install --no-cache-dir \
        nvidia-ml-py3 \
        torch==${PYTORCH_VERSION} \
        torchvision \
        torchaudio \
        --extra-index-url=https://download.pytorch.org/whl/$short_cuda_version
}

build_nvidia_run_tests() {
    installed_pytorch_cuda_version=$("$PYTHON_VENV_PYTHON" -c "import torch; print(torch.version.cuda)")
    if [[ "$CUDA_VERSION" != "$installed_pytorch_cuda"* ]]; then
        echo "Expected PyTorch CUDA ${CUDA_VERSION} but found ${installed_pytorch_cuda}\n"
        exit 1
    fi
}

build_nvidia_main "$@"