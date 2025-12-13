#!/usr/bin/env bash

# ComfyUI 3D GenAI Entrypoint Script
# Handles custom node installation with 3D-Pack support

set -e

echo "=========================================="
echo "ComfyUI 3D GenAI Container Starting..."
echo "=========================================="

# --- Ensure user directories exist ---
mkdir -p /app/ComfyUI/user /app/ComfyUI/user/default
chown -R "$(id -u)":"$(id -g)" /app/ComfyUI/user 2>/dev/null || true
chmod -R u+rwX /app/ComfyUI/user 2>/dev/null || true

# --- ComfyUI-Manager config ---
CFG_DIR="/app/ComfyUI/user/default/ComfyUI-Manager"
CFG_FILE="$CFG_DIR/config.ini"
DB_DIR="$CFG_DIR"
DB_PATH="${DB_DIR}/manager.db"
SQLITE_URL="sqlite:////${DB_PATH}"

mkdir -p "$CFG_DIR"

if [ ! -f "$CFG_FILE" ]; then
  echo "↳ Creating ComfyUI-Manager config.ini"
  cat > "$CFG_FILE" <<EOF
[default]
use_uv = False
file_logging = False
db_mode = cache
database_url = ${SQLITE_URL}
EOF
else
  echo "↳ ComfyUI-Manager config exists"
fi

# --- Custom Nodes Installation ---
CN_DIR=/app/ComfyUI/custom_nodes
INIT_MARKER="$CN_DIR/.custom_nodes_initialized"

declare -A REPOS=(
  # --- Core Nodes ---
  ["ComfyUI-Manager"]="https://github.com/ltdrdata/ComfyUI-Manager.git"
  ["ComfyUI_essentials"]="https://github.com/cubiq/ComfyUI_essentials.git"
  ["ComfyUI-Crystools"]="https://github.com/crystian/ComfyUI-Crystools.git"
  ["rgthree-comfy"]="https://github.com/rgthree/rgthree-comfy.git"
  ["ComfyUI-KJNodes"]="https://github.com/kijai/ComfyUI-KJNodes.git"
  
  # --- 3D GenAI Nodes ---
  ["ComfyUI-3D-Pack"]="https://github.com/MrForExample/ComfyUI-3D-Pack.git"
  ["comfyui-3d-gs-renderer"]="https://github.com/swhsiang/comfyui-3d-gs-renderer.git"
  ["comfyui_controlnet_aux"]="https://github.com/Fannovel16/comfyui_controlnet_aux.git"
  ["ComfyUI-VideoHelperSuite"]="https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
)

if [ ! -f "$INIT_MARKER" ]; then
  echo ""
  echo "=========================================="
  echo "First run: Installing custom nodes..."
  echo "=========================================="
  
  mkdir -p "$CN_DIR"
  
  for name in "${!REPOS[@]}"; do
    url="${REPOS[$name]}"
    target="$CN_DIR/$name"
    if [ -d "$target" ]; then
      echo "  ✓ $name already exists"
    else
      echo "  ↳ Cloning $name..."
      git clone --depth 1 "$url" "$target" 2>/dev/null || {
        echo "  ✗ Failed to clone $name"
        continue
      }
    fi
  done

  echo ""
  echo "=========================================="
  echo "Installing node dependencies..."
  echo "=========================================="
  
  # Install ComfyUI-3D-Pack first (has install.py)
  if [ -d "$CN_DIR/ComfyUI-3D-Pack" ]; then
    echo "  ↳ Installing ComfyUI-3D-Pack..."
    cd "$CN_DIR/ComfyUI-3D-Pack"
    
    # Install requirements first
    if [ -f "requirements.txt" ]; then
      echo "    ↳ Installing requirements.txt..."
      python -m pip install --no-cache-dir --user -r requirements.txt 2>&1 | tail -5 || true
    fi
    
    # Run install.py if it exists
    if [ -f "install.py" ]; then
      echo "    ↳ Running install.py..."
      python install.py 2>&1 | tail -10 || true
    fi
    
    cd /app/ComfyUI
  fi

  # Install other node dependencies
  for dir in "$CN_DIR"/*/; do
    name=$(basename "$dir")
    
    # Skip 3D-Pack (already handled)
    if [ "$name" = "ComfyUI-3D-Pack" ]; then
      continue
    fi
    
    req="$dir/requirements.txt"
    if [ -f "$req" ]; then
      echo "  ↳ Installing deps for $name..."
      python -m pip install --no-cache-dir --user -r "$req" 2>&1 | tail -3 || true
    fi
  done

  # Create marker file
  touch "$INIT_MARKER"
  
  echo ""
  echo "=========================================="
  echo "Custom nodes installation complete!"
  echo "=========================================="
else
  echo "↳ Custom nodes already initialized"
fi

echo ""
echo "=========================================="
echo "Launching ComfyUI..."
echo "=========================================="
echo ""

exec "$@"
