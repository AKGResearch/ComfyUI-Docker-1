# ComfyUI Docker Build File v1.0.1 by John Aldred
# https://www.johnaldred.com
# https://github.com/kaouthia

# Use NVIDIA CUDA base image with Python for GPU support
# Using CUDA 12.1 devel image with cuDNN for PyTorch compatibility
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Allow passing in your host UID/GID (defaults 1000:1000)
ARG UID=1000
ARG GID=1000

# Install Python 3.10 and OS deps, create the non-root user
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git \
      python3 \
      python3-pip \
      python3-venv \
 && groupadd --gid ${GID} appuser \
 && useradd --uid ${UID} --gid ${GID} --create-home --shell /bin/bash appuser \
 && rm -rf /var/lib/apt/lists/*

# Set Python 3 as default python command
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install Mesa/GL and GLib so OpenCV can load libGL.so.1 for ComfyUI-VideoHelperSuite
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libgl1 \
      libglx-mesa0 \
      libglib2.0-0 \
      fonts-dejavu-core \
      fontconfig \
 && rm -rf /var/lib/apt/lists/*

# Copy and enable the startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to non-root user
USER $UID:$GID

# make ~/.local/bin available on the PATH so scripts like tqdm, torchrun, etc. are found
ENV PATH=/home/appuser/.local/bin:$PATH

# Set the working directory
WORKDIR /app

# Clone the ComfyUI repository (replace URL with the official repo)
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

# Change directory to the ComfyUI folder
WORKDIR /app/ComfyUI

# Install PyTorch with CUDA 12.1 support first (more stable for Docker)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install remaining ComfyUI dependencies
RUN pip install --no-cache-dir -r requirements.txt

# (Optional) Clean up pip cache to reduce image size
RUN pip cache purge

# Expose the port that ComfyUI will use (change if needed)
EXPOSE 8188

# Run entrypoint first, then start ComfyUI
ENTRYPOINT ["/entrypoint.sh"]
CMD ["python","/app/ComfyUI/main.py","--listen","0.0.0.0"]
