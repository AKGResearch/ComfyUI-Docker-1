@echo off
echo ==========================================
echo Downloading 360 Panorama Workflow Models
echo ==========================================
echo.

REM Create directories if they don't exist
if not exist "D:\Projects\Diffusion\models\controlnet" mkdir "D:\Projects\Diffusion\models\controlnet"
if not exist "D:\Projects\Diffusion\models\ipadapter" mkdir "D:\Projects\Diffusion\models\ipadapter"
if not exist "D:\Projects\Diffusion\models\clip_vision" mkdir "D:\Projects\Diffusion\models\clip_vision"

echo.
echo [1/5] Downloading ControlNet Canny model (~1.4GB)...
curl -L -o "D:\Projects\Diffusion\models\controlnet\control_v11p_sd15_canny.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"

echo.
echo [2/5] Downloading ControlNet Depth model (~1.4GB)...
curl -L -o "D:\Projects\Diffusion\models\controlnet\control_v11f1p_sd15_depth.pth" "https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"

echo.
echo [3/5] Downloading IP-Adapter SD15 model (~44MB)...
curl -L -o "D:\Projects\Diffusion\models\ipadapter\ip-adapter_sd15.safetensors" "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter_sd15.safetensors"

echo.
echo [4/5] Downloading IP-Adapter Plus SD15 model (~98MB)...
curl -L -o "D:\Projects\Diffusion\models\ipadapter\ip-adapter-plus_sd15.safetensors" "https://huggingface.co/h94/IP-Adapter/resolve/main/models/ip-adapter-plus_sd15.safetensors"

echo.
echo [5/5] Downloading CLIP Vision model (~2.5GB)...
curl -L -o "D:\Projects\Diffusion\models\clip_vision\CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors" "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors"

echo.
echo ==========================================
echo Download Complete!
echo ==========================================
echo.
echo Models downloaded to:
echo   - D:\Projects\Diffusion\models\controlnet\
echo   - D:\Projects\Diffusion\models\ipadapter\
echo   - D:\Projects\Diffusion\models\clip_vision\
echo.
pause
