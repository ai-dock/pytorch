import torch
import os
required_version = os.environ.get("PYTORCH_VERSION")
actual_version = torch.__version__
# Vaguely handle version+platform type string
if not actual_version.startswith(required_version):
    print(f"Expected pytorch v{required_version} but found v{actual_version}")
    exit(1)

