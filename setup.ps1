# ComfyUI Docker 3D GenAI Setup Script
# Creates all necessary directories for the Docker setup

Write-Host "ComfyUI Docker 3D GenAI Setup" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

$baseDir = $PSScriptRoot

# Define directory structure
$directories = @(
    # Shared directories
    "data/models/checkpoints",
    "data/models/vae",
    "data/models/loras",
    "data/models/controlnet",
    "data/models/upscale_models",
    "data/models/embeddings",
    "data/models/clip",
    "data/models/unet",
    "data/input",
    
    # 3D Model checkpoints (shared across 3D instances)
    "data/models_3d/hunyuan3d",
    "data/models_3d/partcrafter",
    "data/models_3d/triposr",
    "data/models_3d/instantmesh",
    "data/models_3d/crm",
    
    # Main instance
    "data/main/custom_nodes",
    "data/main/user",
    "data/main/output",
    
    # Test instance
    "data/test/custom_nodes",
    "data/test/user",
    "data/test/output",
    
    # 3D GenAI instance
    "data/3d/custom_nodes",
    "data/3d/user",
    "data/3d/output"
)

Write-Host "Creating directory structure..." -ForegroundColor Yellow
foreach ($dir in $directories) {
    $fullPath = Join-Path $baseDir $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Green
    } else {
        Write-Host "  Exists:  $dir" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Place your models in data/models/ subdirectories"
Write-Host "  2. Place 3D model checkpoints in data/models_3d/ subdirectories"
Write-Host "  3. Build and run: docker compose build --no-cache && docker compose up -d"
Write-Host ""
Write-Host "Container Access:" -ForegroundColor Cyan
Write-Host "  - Main instance:  http://localhost:8189"
Write-Host "  - Test instance:  http://localhost:8190"
Write-Host "  - 3D instance:    http://localhost:8191"
Write-Host ""
Write-Host "3D GenAI Features:" -ForegroundColor Cyan
Write-Host "  - Hunyuan3D 2.1: Image to 3D mesh with textures"
Write-Host "  - PartCrafter: 3D mesh with part segmentation"
Write-Host "  - TripoSR: Fast single-image to 3D"
Write-Host "  - 3DGS Renderer: Gaussian Splatting visualization"
Write-Host ""
