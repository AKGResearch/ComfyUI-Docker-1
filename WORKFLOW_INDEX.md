# ComfyUI Workflow Index

## Overview
This document catalogs all workflows and maps them to required custom nodes, models, and recommended Docker containers.

---

## Docker Container Mapping

| Container | Port | Purpose | Key Nodes |
|-----------|------|---------|-----------|
| `comfyui-main` | 8189 | General/Stable workflows | Core nodes, VHS, rgthree |
| `comfyui-test` | 8190 | Testing new workflows | Same as main |
| `comfyui-3d` | 8191 | 3D generation (pre-built) | 3D-Pack (limited) |
| `comfyui-3d-test` | 8192 | 3D generation (custom build) | Full 3D-Pack support |

---

## Workflow Categories

### 🎬 VIDEO - WAN 2.x (Image-to-Video / Text-to-Video)

| Workflow | Container | Status |
|----------|-----------|--------|
| `video_wan2_2_14B_i2v_vGA.json` | comfyui-main | ✅ Ready |
| `video_wan2_2_14B_i2v_working.json` | comfyui-main | ✅ Ready |
| `WAN2.1 - IMG to VIDEO 1.6.json` | comfyui-main | ✅ Ready |
| `t2v_2step_wan.json` | comfyui-main | ✅ Ready |
| `WAN2.2 T2V-I2V-S2V K3NK v2.3.json` | comfyui-main | ⚠️ Check nodes |

**Required Models:**
- `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors` ✅
- `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors` ✅
- `umt5_xxl_fp8_e4m3fn_scaled.safetensors` ✅
- `wan_2.1_vae.safetensors` ✅

**Required Custom Nodes:**
- `ComfyUI-VideoHelperSuite` (VHS_VideoCombine, VHS_LoadVideoPath)
- `rgthree-comfy` (Fast Groups Bypasser, Display Any)
- `ComfyUI-KJNodes` (WanVideoTeaCacheKJ, PathchSageAttentionKJ)
- `ComfyUI-mxToolkit` (mxSlider, mxSlider2D)
- `ComfyUI-pysssss` (MathExpression, ShowText)

---

### 🎬 VIDEO - Mochi

| Workflow | Container | Status |
|----------|-----------|--------|
| `mochi_example_49_frames_16GB_vGA.json` | comfyui-main | ⚠️ Check |
| `mochi_example_49_frames_16GB_vGA2.json` | comfyui-main | ⚠️ Check |
| `mochi_example_49_frames_16GB_vGA3.json` | comfyui-main | ⚠️ Check |

**Required Models:**
- `mochi_preview_dit_GGUF_Q4_0_v2.safetensors` ✅

**Required Custom Nodes:**
- `ComfyUI-MochiWrapper` (DownloadAndLoadMochiModel, MochiSampler, MochiDecodeSpatialTiling)
- `ComfyUI-VideoHelperSuite` (VHS_VideoCombine)
- `ComfyUI-CLIP-Interrogator` (ComfyUIClipInterrogator)
- `ComfyUI-pysssss` (ShowText)

---

### 🎬 VIDEO - LTX Video

| Workflow | Container | Status |
|----------|-----------|--------|
| `ltxvideo-i2v_vGA.json` | comfyui-main | ⚠️ Check |
| `workflow-ltx-video-video-to-video-*.json` | comfyui-main | ⚠️ Check |
| `workflow-all-in-one-custom_vGA.json` | comfyui-main | ⚠️ Check |

**Required Models:**
- `ltx-video-2b-v0.9.1.safetensors` ✅

**Required Custom Nodes:**
- `ComfyUI-LTXVideo` (LTXVLoader, LTXVApplySTG, LTXVShiftSigmas)
- `ComfyUI-Florence2` (DownloadAndLoadFlorence2Model, Florence2Run)
- `ComfyUI-VideoHelperSuite` (VHS_VideoCombine)
- `ComfyUI-KJNodes` (ImageResizeKJ)
- `comfy-mtb` (String Replace)
- `ComfyUI-pysssss` (StringFunction)
- `ComfyUI-Frame-Interpolation` (RIFE VFI)

---

### 🎬 VIDEO - Inpainting / Vid2Vid

| Workflow | Container | Status |
|----------|-----------|--------|
| `InpaintvidV1_vGA.json` | comfyui-main | ⚠️ Complex |
| `workflow-stefan_vid2vid_vGA.json` | comfyui-main | ⚠️ Check |

**Required Custom Nodes:**
- `ComfyUI-Advanced-ControlNet` (ACN_AdvancedControlNetApply)
- `ComfyUI-Impact-Pack` (ImpactImageBatchToImageList, ImpactSwitch)
- `ComfyUI-IPAdapter-plus` (IPAdapterAdvanced, IPAdapterUnifiedLoader)
- `ComfyUI-segment-anything-2` (DownloadAndLoadSAM2Model, Sam2Segmentation)
- `rgthree-comfy` (Power Prompt, Display Any, Fast Groups Bypasser)
- `ComfyUI-VideoHelperSuite` (VHS_LoadVideoPath, VHS_VideoCombine)
- `was-node-suite-comfyui` (Image To Mask, Paste By Mask, etc.)

---

### 🖼️ IMAGE - Test/Basic

| Workflow | Container | Status |
|----------|-----------|--------|
| `image_test.json` | comfyui-main | ✅ Basic |
| `workflow_test1.json` | comfyui-main | ✅ Basic |

---

## Required Custom Nodes Summary

### Core (Already in entrypoint.sh)
- ✅ `ComfyUI-Manager`
- ✅ `ComfyUI_essentials`
- ✅ `ComfyUI-Crystools`
- ✅ `rgthree-comfy`
- ✅ `ComfyUI-KJNodes`
- ✅ `ComfyUI_UltimateSDUpscale`

### Need to Add
- ❌ `ComfyUI-VideoHelperSuite` - Video encoding/decoding
- ❌ `ComfyUI-MochiWrapper` - Mochi video model support
- ❌ `ComfyUI-LTXVideo` - LTX video model support
- ❌ `ComfyUI-Florence2` - Image captioning
- ❌ `ComfyUI-Impact-Pack` - Advanced image processing
- ❌ `ComfyUI-IPAdapter-plus` - IP Adapter support
- ❌ `ComfyUI-Advanced-ControlNet` - Advanced ControlNet
- ❌ `ComfyUI-segment-anything-2` - SAM2 segmentation
- ❌ `ComfyUI-Frame-Interpolation` - RIFE/FILM frame interpolation
- ❌ `ComfyUI-mxToolkit` - Sliders and UI helpers
- ❌ `ComfyUI-pysssss` - String functions, ShowText
- ❌ `comfy-mtb` - String replace, various utilities
- ❌ `was-node-suite-comfyui` - Image manipulation nodes
- ❌ `ComfyUI-GGUF` - GGUF model loading

---

## Models Inventory

### ✅ Available
| Type | Model | Size |
|------|-------|------|
| Diffusion | wan2.2_i2v_high_noise_14B_fp8_scaled | ~14GB |
| Diffusion | wan2.2_i2v_low_noise_14B_fp8_scaled | ~14GB |
| Diffusion | wan2.1_fun_camera_v1.1_1.3B_bf16 | ~1.3GB |
| Diffusion | mochi_preview_dit_GGUF_Q4_0_v2 | ~4GB |
| Checkpoint | ltx-video-2b-v0.9.1 | ~2GB |
| Checkpoint | v1-5-pruned-emaonly-fp16 | ~2GB |
| Text Encoder | umt5_xxl_fp8_e4m3fn_scaled | ~6.7GB |
| Text Encoder | t5xxl_fp8_e4m3fn | ~4.9GB |
| VAE | wan_2.1_vae | ~300MB |
| CLIP Vision | clip_vision_h | ~1GB |

### ❓ May Need (for SmoothMix)
| Type | Model | Source |
|------|-------|--------|
| LoRA | SmoothMix Animations Low | CivitAI 2040641 |
| LoRA | SmoothMix Animations High | CivitAI 2040641 |
| Checkpoint | Smooth Mix Wan 2.2 I2V | CivitAI 1995784 |

---

## Workflow Locations

```
data/
├── main/
│   ├── user/default/workflows/    ← PRIMARY (14 files)
│   └── workflows/                  ← K3NK workflow (1 file)
└── settings/workflows/             ← DUPLICATE (remove?)
```

**Recommendation:** Consolidate to `data/main/user/default/workflows/` as the single source.

---

## Next Steps

1. **Add missing custom nodes** to `entrypoint.sh`
2. **Test each workflow** in comfyui-main container
3. **Download SmoothMix models** from CivitAI
4. **Create specialized containers** if needed (e.g., video-heavy vs image-heavy)
