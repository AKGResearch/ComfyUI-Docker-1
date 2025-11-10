# ComfyUI Docker Setup Notes

## Overview
This is a Docker setup for ComfyUI based on John Aldred's approach with modifications for Windows GPU support and persistent model storage.

**Key Change**: Updated base image from `python:3.12-slim-bookworm` to `nvidia/cuda:12.6.0-cudnn-runtime-ubuntu22.04` to enable GPU support.

## Directory Structure
```
ComfyUI-Docker-1/
├── data/                          # Persistent data (gitignored)
│   ├── models/                    # SHARED: Model files (read-only)
│   │   ├── checkpoints/          # Main SD models
│   │   ├── vae/                  # VAE models
│   │   ├── loras/                # LoRA models
│   │   ├── controlnet/           # ControlNet models
│   │   ├── upscale_models/       # Upscaler models
│   │   └── embeddings/           # Textual Inversion embeddings
│   ├── input/                     # SHARED: Input images (read-only)
│   ├── main/                      # Main instance data
│   │   ├── custom_nodes/         # Custom nodes for main instance
│   │   ├── user/                 # Workflows & settings for main instance
│   │   └── output/               # Generated images for main instance
│   └── test/                      # Test instance data
│       ├── custom_nodes/         # Custom nodes for test instance
│       ├── user/                 # Workflows & settings for test instance
│       └── output/               # Generated images for test instance
├── Dockerfile                     # Container build instructions
├── docker-compose.yml             # Docker Compose configuration
├── entrypoint.sh                  # Container startup script
├── setup.ps1                      # Windows setup script
└── README.md                      # Original documentation
```

## Quick Start

### 1. Run Setup Script
```powershell
.\setup.ps1
```

This creates all necessary directories with proper structure.

### 2. Build the Container
```powershell
docker compose build --no-cache
```

### 3. Start ComfyUI
```powershell
docker compose up -d
```

### 4. Access ComfyUI
- **Main instance** (comfyui-main): http://localhost:8189
- **Test instance** (comfyui-test): http://localhost:8190

## Multi-Instance Setup

This configuration runs TWO ComfyUI instances that share the same models but have separate:
- Custom nodes
- Workflows and settings
- Output folders

### Why Multiple Instances?

**Benefits:**
- **Shared Models**: Large model files (GBs) are stored once and shared (read-only) across instances
- **Isolated Testing**: Test new custom nodes or workflows without affecting your stable setup
- **Parallel Workflows**: Run different workflows simultaneously on the same GPU
- **Easy Rollback**: If instance2 breaks, instance1 is unaffected

### Volume Strategy

| Resource | Sharing | Mount Mode | Reason |
|----------|---------|------------|--------|
| Models | SHARED | Read-only (`:ro`) | Large files, rarely change, prevent accidents |
| Input | SHARED | Read-only (`:ro`) | Reuse input images across instances |
| Custom Nodes | ISOLATED | Read-write (`:rw`) | Test different node configurations |
| Workflows/Settings | ISOLATED | Read-write (`:rw`) | Experiment with different workflows |
| Outputs | ISOLATED | Read-write (`:rw`) | Keep outputs organized per instance |

### Managing Instances

**Start both instances:**
```powershell
docker compose up -d
```

**Start only main instance:**
```powershell
docker compose up -d comfyui-main
```

**Start only test instance:**
```powershell
docker compose up -d comfyui-test
```

**Stop specific instance:**
```powershell
docker compose stop comfyui-test
```

**View logs for specific instance:**
```powershell
docker logs comfyui-main -f
docker logs comfyui-test -f
```

## GPU Configuration

### Current Status
The container is configured for NVIDIA GPU support using:
```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```

### Troubleshooting GPU Issues

If you see CUDA errors like:
```
RuntimeError: Unexpected error from cudaGetDeviceCount(). 
Error 500: named symbol not found
```

**Possible causes:**
1. **NVIDIA drivers not installed** - Install latest NVIDIA drivers for Windows with WSL2 support
2. **NVIDIA Container Toolkit not installed** (Linux only) - Windows users only need drivers
3. **Docker Desktop GPU support not enabled** - Check Docker Desktop settings
4. **CUDA version mismatch** - The PyTorch version in the container may not match your GPU drivers

**Solutions:**

**Option 1: Update NVIDIA Drivers (Windows)**
- Download latest drivers from: https://www.nvidia.com/Download/index.aspx
- Ensure WSL2 support is included

**Option 2: Run in CPU Mode**
Add to `docker-compose.yml` under the `comfyui` service:
```yaml
environment:
  - COMMANDLINE_ARGS=--cpu
```
And remove the `deploy` section.

**Option 3: Check Docker Desktop Settings**
1. Open Docker Desktop
2. Go to Settings → Resources → WSL Integration
3. Ensure WSL2 integration is enabled
4. Go to Settings → Docker Engine
5. Verify GPU support is configured

## Managing Models

### Adding Models
Place your model files in the appropriate subdirectory:
- Checkpoint models: `data/models/checkpoints/`
- VAE models: `data/models/vae/`
- LoRA models: `data/models/loras/`
- etc.

The container will automatically detect them on next restart.

### Model Persistence
All models are stored outside the container in `./data/models/`, so they persist even if you:
- Rebuild the container
- Update ComfyUI
- Delete and recreate the container

## Custom Nodes

Custom nodes are managed in two ways:

### 1. Pre-installed Nodes (Persistent across rebuilds)
Edit `entrypoint.sh` and add to the `REPOS` array:
```bash
declare -A REPOS=(
  ["ComfyUI-Manager"]="https://github.com/ltdrdata/ComfyUI-Manager.git"
  ["YourCustomNode"]="https://github.com/user/YourCustomNode.git"
)
```

### 2. Runtime Installed Nodes (Lost on rebuild)
Install via ComfyUI Manager in the web interface. These are stored in `data/settings/` but their Python dependencies are lost when the container is rebuilt.

## Useful Commands

### View Logs
```powershell
docker logs comfyui -f
```

### Stop Container
```powershell
docker compose down
```

### Restart Container
```powershell
docker compose restart
```

### Rebuild Container (after code changes)
```powershell
docker compose down
docker compose build --no-cache
docker compose up -d
```

### Access Container Shell
```powershell
docker exec -it comfyui /bin/bash
```

## Updating ComfyUI

To update to the latest version of ComfyUI:
```powershell
docker compose down
docker compose build --no-cache
docker compose up -d
```

This pulls the latest ComfyUI from GitHub and rebuilds with fresh dependencies.

## Port Configuration

Default port: `8188`

To change the port, edit `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:8188"
```

## References

- **lecode-official/comfyui-docker**: https://github.com/lecode-official/comfyui-docker
- **John Aldred's Tutorial**: https://www.johnaldred.com/running-comfyui-in-docker-on-windows-or-linux/
- **ComfyUI GitHub**: https://github.com/comfyanonymous/ComfyUI
- **ComfyUI Manager**: https://github.com/ltdrdata/ComfyUI-Manager

## Notes

- **Permission errors on Windows**: The `chown` and `chmod` commands in `entrypoint.sh` have been commented out as they cause issues with Windows volume mounts
- **Model organization**: The subdirectory structure in `data/models/` follows ComfyUI conventions for automatic model detection
- **Settings persistence**: All ComfyUI settings and user data are stored in `data/settings/`
