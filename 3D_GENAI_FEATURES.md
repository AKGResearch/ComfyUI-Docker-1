# ComfyUI 3D GenAI Features Enhancement Plan

## Vision
Enable high-quality 3D content generation in ComfyUI with:
- **Independent 3D models** with image-model-level detail for people/characters
- **3D Gaussian Splatting** for immersive spaces and environments
- **Physics-based rendering** for realistic physical components

---

## Key Technologies Identified

### 1. ComfyUI-3D-Pack (Primary)
**Repository:** https://github.com/MrForExample/ComfyUI-3D-Pack

The most comprehensive 3D node suite for ComfyUI. Supports:

| Feature | Description |
|---------|-------------|
| **Hunyuan3D 2.1** | Single image → 3D mesh with RGB texture (Tencent) |
| **PartCrafter** | Image → 3D mesh with part segmentation |
| **MV-Adapter** | Multi-view generation from image/text + mesh |
| **TripoSR** | Fast single-image to 3D |
| **InstantMesh** | High-quality mesh generation |
| **3DGS Visualization** | Real-time Gaussian Splatting preview |
| **Deep Marching Tetrahedrons** | Convert 3DGS to mesh (.obj, .ply, .glb) |

**Requirements:**
- Windows 10/11, Python 3.12, CUDA 12.4, torch 2.5.1+cu124
- Visual Studio Build Tools (for JIT compilation)
- Pre-builds available for automatic installation

### 2. ComfyUI-3D-GS-Renderer
**Repository:** https://github.com/swhsiang/comfyui-3d-gs-renderer

Lightweight Gaussian Splatting renderer using Forge/THREE.js:
- Supports .PLY, .SPZ, .SPLAT, .KSPLAT formats
- Real-time rendering in browser
- Good for previewing and iterating on 3D spaces

### 3. 360° Panorama Workflow
**Source:** https://yonlog.substack.com/p/create-360-ai-panoramas-comfyui-3d-lookdev

Workflow for environment design:
1. Render 360° panorama from 3D scene (Unreal/Blender)
2. Use ControlNet to generate AI variations
3. Project back into 3D using spherical mapping
4. Iterate on materials, textures, lighting

### 4. Blender + ComfyUI Integration
**Source:** https://canadiantechnologymagazine.com/create-amazing-3d-scenes-blender-comfyui-ai/

NVIDIA RTX 3D Guided Generative AI:
- Apply AI textures to 3D environments
- Fill empty spaces intelligently
- Transform scenes with text prompts
- Requires high-end GPU (RTX 4080+, 48GB RAM recommended)

---

## Use Case Mapping

### People/Characters (High Detail)
| Goal | Solution |
|------|----------|
| Single image → 3D character | Hunyuan3D 2.1 + PartCrafter |
| Character with part segmentation | PartCrafter (body parts as separate meshes) |
| Multi-view consistency | MV-Adapter (IG2MV mode) |
| Texture refinement | MV-Adapter Texturing workflow |

**Roadmap item:** CharacterGen integration planned for ComfyUI-3D-Pack

### Spaces/Environments (3D Splatting)
| Goal | Solution |
|------|----------|
| Scene from single image | PartCrafter-Scene mode |
| Real-time 3DGS preview | comfyui-3d-gs-renderer |
| Environment lookdev | 360° panorama workflow |
| Interior design | ControlNet (Canny, M-lsd, Scribbles) |

### Physical Components (Science-Based)
| Goal | Solution |
|------|----------|
| Mesh export for simulation | Deep Marching Tetrahedrons → .obj/.glb |
| UV textures for PBR | MV-Adapter Texturing |
| NeRF-based reconstruction | InstantNGP nodes |
| Structure preservation | ControlNet with depth/normal maps |

---

## Docker Implementation Plan

### Phase 1: Core 3D Support
Add essential 3D nodes to `entrypoint.sh`:
```bash
["ComfyUI-3D-Pack"]="https://github.com/MrForExample/ComfyUI-3D-Pack.git"
["comfyui-3d-gs-renderer"]="https://github.com/swhsiang/comfyui-3d-gs-renderer.git"
```

### Phase 2: Enhanced Dockerfile
- Upgrade to CUDA 12.4 for ComfyUI-3D-Pack compatibility
- Add Visual Studio Build Tools (or gcc/g++ for Linux)
- Increase shared memory for 3DGS operations

### Phase 3: Model Storage
Create model directories:
```
data/models/
├── 3d/
│   ├── hunyuan3d/
│   ├── partcrafter/
│   ├── triposr/
│   └── instantmesh/
```

### Phase 4: Workflow Templates
Add example workflows for:
- Image → 3D character
- Scene → 3DGS environment
- 360° panorama generation
- PBR texture generation

---

## Hardware Considerations

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| GPU | RTX 3060 12GB | RTX 4080+ 16GB |
| VRAM | 12GB | 24GB+ |
| RAM | 32GB | 48GB+ |
| Storage | 100GB | 500GB+ (models) |

**Note:** ComfyUI-3D-Pack is GPU-intensive. Consider:
- Dedicated 3D container with higher resource limits
- Separate model cache for 3D checkpoints (~50GB+)

---

## References

1. [ComfyUI-3D-Pack](https://github.com/MrForExample/ComfyUI-3D-Pack)
2. [comfyui-3d-gs-renderer](https://github.com/swhsiang/comfyui-3d-gs-renderer)
3. [360° AI Panoramas Workflow](https://yonlog.substack.com/p/create-360-ai-panoramas-comfyui-3d-lookdev)
4. [Blender + ComfyUI Tutorial](https://canadiantechnologymagazine.com/create-amazing-3d-scenes-blender-comfyui-ai/)
5. [Comfy3D Introduction](https://radiancefields.com/comfy3d-for-comfyui)
6. [Interior Design with ComfyUI](https://www.comflowy.com/blog/generate-interior-design-renderings)
