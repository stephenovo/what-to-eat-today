# 食材识图模型选型（2026-08-30）

## 结论

当前最适合“拍一张、快速识别食材并返回可入库结果”的大模型方案是 **Gemini 3.5 Flash-Lite**，通过 **Firebase AI Logic（Swift SDK）+ Firebase App Check** 接入。

选择它的原因：

- 原生支持图片输入与结构化 JSON 输出，适合直接映射到项目的 `ingredientID`。
- Flash-Lite 面向低延迟与低成本场景；免费层的输入和输出目前均免费。
- Firebase AI Logic 可让 iOS 客户端调用 Gemini，而不把长期 API Key 硬编码进 App；还能配合 App Check 和按用户限流。
- Swift SDK 支持 iOS，接入成本明显低于在手机端运行 2B/4B 视觉语言模型。

官方资料：[Gemini 3.5 Flash-Lite](https://ai.google.dev/gemini-api/docs/models/gemini-3.5-flash-lite)、[Gemini API 定价](https://ai.google.dev/gemini-api/docs/pricing)、[Firebase AI Logic](https://firebase.google.com/docs/ai-logic)、[图片理解](https://ai.google.dev/gemini-api/docs/image-understanding)。

## 推荐实现

第一阶段使用单图识别，并把模型输出限制为项目词典中的 ID：

```json
{
  "ingredientID": "tomato",
  "name": "番茄",
  "confidence": 0.97,
  "alternatives": ["red_bell_pepper"]
}
```

产品流程为“拍照 → 返回 1 个主候选和最多 3 个备选 → 用户确认 → 加入冰箱”。低置信度结果必须让用户选择，不能自动入库。佐料也使用同一词典和结果格式。

安全上应启用 App Check、按用户限流和预算告警。Gemini 官方明确不建议把 API Key 直接放进移动端代码：[API Key 安全说明](https://ai.google.dev/gemini-api/docs/api-key)、[Firebase AI Logic 安全清单](https://firebase.google.com/docs/ai-logic/security-checklist)。

## 备选方案

| 方案 | 优点 | 局限 | 结论 |
| --- | --- | --- | --- |
| Gemini 3.5 Flash-Lite + Firebase | 快、结构化输出、iOS 接入简单、有免费层 | 依赖网络；免费层数据政策与付费层不同 | 当前首选 |
| Qwen3-VL-2B-Instruct | Apache-2.0、开放权重、可自托管 | iPhone 端包体、内存和速度压力明显；部署复杂 | 适合自建服务器，不适合当前直接端侧集成 |
| Core ML 自训练分类器 | 完全端侧、毫秒级、隐私最好、每次识别零成本 | 不是通用大模型，需要收集并标注项目食材图片 | 第二阶段高频食材加速层 |

备选资料：[Qwen3-VL 官方仓库](https://github.com/QwenLM/Qwen3-VL)、[Apple Core ML 模型](https://developer.apple.com/machine-learning/models/)、[Core ML](https://developer.apple.com/documentation/CoreML)。

## 免费层注意事项

Gemini 免费层适合开发与小规模测试，但配额和政策可能变化，不应视作永久 SLA。当前定价页显示免费层数据可用于改进产品，而付费层不用于该目的；涉及真实用户冰箱照片时，应在隐私说明中明确披露，并优先评估付费层。长期最理想的架构是：端侧 Core ML 先识别高频食材，低置信度或未知物品再交给 Gemini。
