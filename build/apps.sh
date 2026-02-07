#!/usr/bin/env bash
set -e

# Install Jupyter, gdown and OhMyRunPod
pip3 install -U --no-cache-dir jupyterlab \
    jupyterlab_widgets \
    ipykernel \
    ipywidgets \
    gdown \
    OhMyRunPod

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

# Install VS Code extensions from local VSIX files
code-server --install-extension /tmp/RSIP-Vision.nvidia-smi-plus-1.0.1.vsix
code-server --install-extension /tmp/vscode-ext.sync-rsync-0.36.0.vsix

# Install VS Code extensions
code-server --install-extension ms-python.python
code-server --install-extension ms-toolsai.jupyter
code-server --install-extension ms-toolsai.vscode-jupyter-powertoys

# Pre-install Jupyter kernel
python3 -m ipykernel install --name "python3" --display-name "Python 3"

# Install RunPod File Uploader
curl -sSL https://github.com/kodxana/RunPod-FilleUploader/raw/main/scripts/installer.sh -o installer.sh && \
    chmod +x installer.sh && \
    ./installer.sh

# Install rclone
curl https://rclone.org/install.sh | bash

# Update rclone
rclone selfupdate

# Install runpodctl (robust download + validation)
apt-get update && apt-get install -y --no-install-recommends ca-certificates curl file && rm -rf /var/lib/apt/lists/*

RUNPODCTL_URL="https://github.com/runpod/runpodctl/releases/download/${RUNPODCTL_VERSION}/runpodctl-linux-amd64"
OUT="/usr/local/bin/runpodctl"

curl -fL --retry 5 --retry-delay 2 --retry-connrefused \
  -A "Mozilla/5.0" \
  -o "$OUT" \
  "$RUNPODCTL_URL"

# Ensure we downloaded a real binary (not "Access Denied" / HTML)
test -s "$OUT"
file "$OUT" | grep -qiE "ELF|executable"

chmod +x "$OUT"
"$OUT" --version || true

# Install croc
curl https://getcroc.schollz.com | bash

# Install speedtest CLI
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt install -y speedtest
