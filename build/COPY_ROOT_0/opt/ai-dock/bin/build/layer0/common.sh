#!/bin/false

# For logic common to cpu, cuda & rocm

build_common_main() {
    :
}

build_common_run_tests() {
    installed_pytorch_version=$("$PYTHON_VENV_PYTHON" -c "import torch; print(torch.__version__)")
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
}

build_common_main "$@"