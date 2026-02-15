
---

# Vertex-Bezier: 实时高维曲线几何映射器
# Vertex-Bezier: GPU-Driven Volumetric Curve Mapping

### 1. 项目概要 | Abstract
本项目开发于 2024 年 6 月（期末考试周期间）。针对 VR 环境下动态高面数几何体生成的性能瓶颈，我利用 **IdeaXR (Godot-based)** 引擎开发了一套基于 **GLSL 顶点着色器** 的映射系统。该系统能将标准立方体实时“挤压、扭转并映射”至贝塞尔曲线路径上，生成具有体积感的动态几何体（如跳绳、牛角状管道等）。

Developed in June 2024, this project addresses the performance bottlenecks of generating dynamic high-poly geometries in VR environments. Using the **IdeaXR** engine, I implemented a mapping system via **GLSL Vertex Shaders** that deforms and maps standard meshes (Cubes) onto Bezier trajectories in real-time, creating volumetric shapes like jump ropes and organic horns.


> **1. 项目概要 | Abstract**
> 
> 本项目展示了一种基于 **GLSL 顶点着色器** 的实时几何映射方法。利用 **IdeaXR** 引擎，我实现了将标准立方体沿贝塞尔曲线路径进行实时挤压与扭转的变形算法。该方法绕过了传统的 CPU 网格生成瓶颈，能够以极高性能在 VR 环境中呈现具有体积感的动态曲线几何体（如跳绳、牛角状管道等）。
>
> This project demonstrates a real-time geometric mapping **method** using **GLSL Vertex Shaders**. Within the **IdeaXR** engine, I implemented an **algorithm** that deforms standard cubes along Bezier paths. By bypassing traditional CPU mesh generation, this **technique** enables high-performance rendering of volumetric curved geometries in VR like jump ropes and organic horns..


<div align="center">
<img width="621" height="363" alt="7aec8c513d9799716392b5121d123825" src="https://github.com/user-attachments/assets/1c66695b-46e4-4d83-baa1-b71d3fd36436" />
</div>

---

### 2. 开发动机：为什么选择 GPU？ | Motivation: Why GPU?
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

### 3. 功能特性 | Features
*   **实时动态交互 (Real-time Interaction):** 支持通过调节参数生成跳绳动画，响应速度极快。
*   **参数化几何控制 (Parametric Geometry):** 允许沿曲线路径动态调节几何体粗细（如通过 $t$ 参数控制生成牛角管）。
*   **动态切空间构建 (Dynamic Local Frame):** 使用二次叉乘构建局部坐标系，确保几何体横截面在曲线扭转时保持正确方向。

<div align="center">
<img width="808" height="402" alt="d5ccbe2d144e1e8d57bb8219624a011b" src="https://github.com/user-attachments/assets/e5ce9e7e-3b63-415b-889b-eca9935b11c6" />
</div>

---

### 4. 技术实现 | Implementation Snippet
<img width="2646" height="2697" alt="Bezier_GPU_Algorithm" src="https://github.com/user-attachments/assets/4184588b-7d63-4e84-9263-6410881831d1" />


---

### 5. 局限性与未来研究 | Limitations & Future Work
*   **高阶曲线对齐:** 目前在二次贝塞尔（3点）下表现完美，但在三次贝塞尔（4点）下存在坐标系突跳（Gimbal Lock 类似问题）。
*   **研究目标:** 我计划引入 **Parallel Transport Frame (PTF)** 算法来取代当前的叉乘方案，以在更复杂的曲线路径下实现平滑的几何生成。
*   **Cubic Curve Alignment:** Currently perfect for Quadratic curves, but faces orientation flips in Cubic setups. I plan to implement **Parallel Transport Frames (PTF)** for smoother geometry generation on complex paths.

---

### 演示链接 | Demo & Links
*   **视频讲解 (Lesson by me):** [项目演示与技术说明-Bilibili](https://www.bilibili.com/video/BV1YZ421T71J/)
*   **平台 (Platform):** IdeaXR / Godot
*   **语言 (Language):** GLSL

<div align="center">
<img width="965" height="631" alt="4538dc38d885161eb52dcd0ac1cab358" src="https://github.com/user-attachments/assets/759af608-358f-44b1-a4e7-9523c2904e8f" />
</div>

Thank you for your reading - by UkawaJun
---
