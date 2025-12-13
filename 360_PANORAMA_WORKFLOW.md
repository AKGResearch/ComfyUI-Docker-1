# 360° Panorama Workflow Setup Guide

This guide explains how to create AI-enhanced 360° panoramas from 3D scenes using ComfyUI.

## Overview

The workflow allows you to:
1. Render a 360° panorama from your 3D scene (Blender/Unreal)
2. Use it as ControlNet input to preserve structure
3. Apply AI styling with IP-Adapter for style reference
4. Generate enhanced 360° panoramas viewable in VR

## Prerequisites

### Models Required (Already Downloaded)
Located in `D:\Projects\Diffusion\models\`:

| Model | Location | Purpose |
|-------|----------|---------|
| `control_v11p_sd15_canny.pth` | `controlnet/` | Structure preservation |
| `control_v11f1p_sd15_depth.pth` | `controlnet/` | Depth-based control |
| `ip-adapter_sd15.safetensors` | `ipadapter/` | Style transfer |
| `ip-adapter-plus_sd15.safetensors` | `ipadapter/` | Enhanced style transfer |
| `CLIP-ViT-H-14-laion2B-s32B-b79K.safetensors` | `clip_vision/` | IP-Adapter vision encoder |

### Custom Nodes Installed
- `ComfyUI_IPAdapter_plus` - Style transfer
- `ComfyUI-Advanced-ControlNet` - ControlNet application
- `comfy_mtb` - Image transformation (shift for seam fix)
- `ComfyMath` - Math operations
- `ComfyUI_preview360panorama` - 360° viewer in browser
- `comfyui_controlnet_aux` - Canny/Depth preprocessors

## Blender Setup for 360° Rendering

### Method 1: Cycles Panoramic Camera

1. **Open Blender** and load your 3D scene
2. **Select your camera** in the Outliner
3. **Go to Camera Properties** (camera icon in Properties panel)
4. **Set Camera Type:**
   - Type: `Panoramic`
   - Panorama Type: `Equirectangular`
5. **Set Resolution:**
   - Go to Output Properties
   - Resolution X: `2048` (or `4096` for high quality)
   - Resolution Y: `1024` (or `2048` - always half of X)
6. **Render Settings:**
   - Render Engine: `Cycles`
   - Samples: `128-256` for preview, `512+` for final
7. **Render:** Press `F12` or Render > Render Image
8. **Save:** Image > Save As > `360_render.png`

### Method 2: EEVEE (Faster, Lower Quality)

1. Same camera setup as above
2. Render Engine: `EEVEE`
3. Note: EEVEE panoramic rendering may have limitations

### Tips for Clean ControlNet Input

- **Remove textures:** Set all materials to flat grey/white
- **Disable shadows:** Uncheck "Cast Shadow" on lights
- **Even lighting:** Use ambient/HDRI lighting
- **Remove small details:** Focus on major shapes

## ComfyUI Workflow Usage

### Access ComfyUI
```
http://localhost:8191
```

### Load the Workflow
1. Open ComfyUI at `http://localhost:8191`
2. Drag and drop `360_panorama_controlnet.json` into the browser
3. Or use Menu > Load > select the workflow file

### Workflow Location
```
C:\Users\akgre\OneDrive\Documents\GitHub\ComfyUI-Docker-3D-GenAI\data\3d\user\default\workflows\360_panorama_controlnet.json
```

### Configure the Workflow

1. **Load your 360° render:**
   - In the first `LoadImage` node, select your Blender render

2. **Load a style reference (optional):**
   - In the second `LoadImage` node, load an image with the style you want

3. **Edit the prompt:**
   - Modify the positive prompt to describe your desired scene
   - Example: `360-degree equirectangular panorama of a cozy cabin interior, warm lighting, wooden walls, fireplace, photorealistic`

4. **Adjust ControlNet strength:**
   - Higher (0.8-1.0): More faithful to original structure
   - Lower (0.4-0.6): More creative freedom

5. **Adjust IP-Adapter strength:**
   - Higher (0.6-0.8): Stronger style influence
   - Lower (0.2-0.4): Subtle style hints

### Run the Workflow
- Click "Queue Prompt" or press `Ctrl+Enter`
- View the 360° result in the `PanoramaViewerNode`

## Example Prompts

### Interior Scenes
```
360-degree equirectangular panorama of a modern minimalist living room, 
white walls, large windows, natural light, indoor plants, 
Scandinavian design, photorealistic, 8k
```

### Exterior Scenes
```
360-degree equirectangular panorama of a Japanese zen garden, 
cherry blossoms, stone path, wooden bridge over koi pond, 
morning mist, peaceful atmosphere, photorealistic
```

### Fantasy/Stylized
```
360-degree equirectangular panorama of a magical forest clearing, 
glowing mushrooms, fairy lights, ancient trees, mystical atmosphere,
fantasy art style, vibrant colors
```

## Seam Fixing (Advanced)

If you see visible seams in the panorama:

1. Use `comfy_mtb` nodes to shift the image by 50%
2. Inpaint the center section
3. Shift back and inpaint again

This technique is detailed in the FLUX 360° workflow on CivitAI.

## Viewing 360° Images

### In ComfyUI
- The `PanoramaViewerNode` provides an interactive 360° viewer

### External Viewers
- **Windows Photos:** Open the image, it may auto-detect as panorama
- **VR Headset:** Import into SteamVR or Oculus
- **Online:** Upload to [Kuula](https://kuula.co/) or [Momento360](https://momento360.com/)

## Troubleshooting

### "Missing node" errors
Restart the container:
```powershell
docker restart comfyui-3d
```

### ControlNet not working
- Ensure the image is loaded correctly
- Check that ControlNet model path is correct
- Try reducing resolution to 1024x512 first

### IP-Adapter errors
- Verify CLIP Vision model is in `clip_vision/` folder
- Check IP-Adapter model is in `ipadapter/` folder

## Next Steps

1. **Test with sample images** before rendering from Blender
2. **Experiment with different ControlNet preprocessors** (Canny, Depth, Normal)
3. **Try different base models** (Realistic Vision, DreamShaper, etc.)
4. **Explore FLUX-based workflows** for higher quality (requires more VRAM)
