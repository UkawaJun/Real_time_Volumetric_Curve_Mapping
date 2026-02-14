
---

# Vertex-Bezier: 实时高维曲线几何映射器
# Vertex-Bezier: GPU-Driven Volumetric Curve Mapping

### 1.项目概要 | Abstract
本项目开发于 2024 年 6 月（期末考试周期间）。针对 VR 环境下动态高面数几何体生成的性能瓶颈，我利用 **IdeaXR (Godot-based)** 引擎开发了一套基于 **GLSL 顶点着色器** 的映射系统。该系统能将标准立方体实时“挤压、扭转并映射”至贝塞尔曲线路径上，生成具有体积感的动态几何体（如跳绳、牛角状管道等）。

Developed in June 2024, this project addresses the performance bottlenecks of generating dynamic high-poly geometries in VR environments. Using the **IdeaXR** engine, I implemented a mapping system via **GLSL Vertex Shaders** that deforms and maps standard meshes (Cubes) onto Bezier trajectories in real-time, creating volumetric shapes like jump ropes and organic horns.

---

### 2.开发动机：为什么选择 GPU？ | Motivation: Why GPU?
在长时间的 VR 课题研究中，我发现传统的 **CPU 动态网格生成方案** 在处理高频交互时存在显著弊端：
1.  **性能开销 (CPU Bottleneck):** 在 VR 环境下（通常需要 90FPS+），若由 CPU 逐帧计算成千上万个顶点坐标并重新上传至显存，会造成严重的掉帧和延迟。
2.  **吞吐量限制:** 生成如“跳绳”或“变粗细的电缆”这类复杂形状时，CPU 的串行计算效率极低。

**本项目的核心逻辑：**
将几何变换逻辑彻底移至 **GPU 顶点着色器**。CPU 仅需传输 3-4 个控制点坐标，所有的坐标变换、法线重计算均在 GPU 并行完成。这种方案实现了**近乎零开销**的几何体生成，极大地释放了 VR 场景中的计算资源。

In my VR research, I observed that traditional **CPU-side mesh generation** has critical drawbacks for high-frequency interactions:
1.  **Bottleneck:** For VR (90FPS+), calculating and re-uploading thousands of vertices via CPU every frame causes significant latency.
2.  **Efficiency:** Sequential CPU processing is inefficient for complex shapes like dynamic ropes.

**The core logic of this project:**
By offloading geometry transformation to the **GPU Vertex Shader**, the CPU only needs to send 3-4 control points. All coordinate transformations and normal recalculations are performed in parallel on the GPU, achieving **near-zero overhead** and freeing up vital resources for VR environments.

---

### 3.功能特性 | Features
*   **实时动态交互 (Real-time Interaction):** 支持通过调节参数生成跳绳动画，响应速度极快。
*   **参数化几何控制 (Parametric Geometry):** 允许沿曲线路径动态调节几何体粗细（如通过 $t$ 参数控制生成牛角管）。
*   **动态切空间构建 (Dynamic Local Frame):** 使用二次叉乘构建局部坐标系，确保几何体横截面在曲线扭转时保持正确方向。

---

### 4.技术实现 | Implementation Snippet
核心算法将模型局部坐标映射为贝塞尔参数空间：
The core algorithm maps local mesh coordinates into Bezier parametric space:

```glsl
// 将顶点沿贝塞尔曲线路径进行法线方向偏移
// Offsetting vertices along the Bezier path based on normals
vec3 map_and_deform(vec3 original_pos) {
    vec3 pt = map(original_pos); // 映射到参数空间 (Map to parametric space)
    vec3 result = Bezier3D(pt);  // GPU 并行计算贝塞尔位置 (Compute Bezier position)
    return result;
}
```

---

### 5.局限性与未来研究 | Limitations & Future Work
*   **高阶曲线对齐:** 目前在二次贝塞尔（3点）下表现完美，但在三次贝塞尔（4点）下存在坐标系突跳（Gimbal Lock 类似问题）。
*   **研究目标:** 我计划引入 **Parallel Transport Frame (PTF)** 算法来取代当前的叉乘方案，以在更复杂的曲线路径下实现平滑的几何生成。
*   **Cubic Curve Alignment:** Currently perfect for Quadratic curves, but faces orientation flips in Cubic setups. I plan to implement **Parallel Transport Frames (PTF)** for smoother geometry generation on complex paths.

---

### 演示链接 | Demo & Links
*   **视频讲解 (Bilibili):** [项目演示与技术说明](https://www.bilibili.com/video/BV1YZ421T71J/)
*   **平台 (Platform):** IdeaXR / Godot
*   **语言 (Language):** GLSL

---
