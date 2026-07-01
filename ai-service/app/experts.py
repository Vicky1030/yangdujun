from app.knowledge_base import knowledge_base
from app.ollama_client import ollama_client
from app.schemas import AiResult, ChatRequest, EnvironmentSnapshot, ReferenceChunk, VisionDiagnosisRequest
from app.settings import settings


def environment_text(environment: EnvironmentSnapshot | None) -> str:
    if not environment:
        return "未提供大棚实时环境数据。"
    return (
        f"大棚：{environment.greenhouse_name or environment.greenhouse_id or '-'}；"
        f"温度：{environment.temperature if environment.temperature is not None else '-'}℃；"
        f"空气湿度：{environment.humidity if environment.humidity is not None else '-'}%；"
        f"CO2：{environment.co2_ppm if environment.co2_ppm is not None else '-'}ppm；"
        f"土壤湿度：{environment.soil_moisture if environment.soil_moisture is not None else '-'}%；"
        f"光照：{environment.light_lux if environment.light_lux is not None else '-'}lux。"
    )


def reference_text(references: list[ReferenceChunk]) -> str:
    if not references:
        return "知识库暂未检索到直接依据。"
    lines = []
    for index, ref in enumerate(references, start=1):
        lines.append(f"[{index}] {ref.source} 第{ref.page or '-'}页：{ref.content}")
    return "\n".join(lines)


def infer_risk_level(text: str) -> str:
    severe_words = ["严重", "高风险", "立即", "大量", "腐烂", "虫害", "病害", "白霉", "蛛网", "蛞蝓"]
    medium_words = ["偏高", "偏低", "建议", "注意", "风险", "异常", "复核", "检查"]
    if any(word in text for word in severe_words):
        return "HIGH"
    if any(word in text for word in medium_words):
        return "MEDIUM"
    return "LOW"


def extract_actions(text: str) -> list[str]:
    actions: list[str] = []
    keywords = ["建议", "应", "需要", "控制", "清理", "通风", "补湿", "降湿", "隔离", "复核", "拍照"]
    for line in text.splitlines():
        stripped = line.strip(" -0123456789.、")
        if stripped and any(keyword in stripped for keyword in keywords):
            actions.append(stripped)
    return actions[:6]


async def chat(request: ChatRequest) -> AiResult:
    references = knowledge_base.search(request.question, top_k=5)
    prompt = f"""
你是羊肚菌智慧大棚专业 AI。请基于知识库依据和实时环境数据回答农户问题。

要求：
1. 使用中文回答，直接、专业、可执行。
2. 不确定时说明需要人工复核。
3. 涉及环境调控时给出温度、湿度、CO2 或土壤湿度相关建议。
4. 不要编造知识库没有支持的标准条文。

农户问题：{request.question}

实时环境：{environment_text(request.environment)}

知识库依据：
{reference_text(references)}
"""
    answer = await ollama_client.generate(settings.text_model, prompt)
    return AiResult(
        answer=answer,
        risk_level=infer_risk_level(answer),
        actions=extract_actions(answer),
        references=references,
        expert_trace=["知识库检索专家", "环境数据分析专家", "文本问答专家", "建议生成专家"],
    )


async def vision_diagnosis(request: VisionDiagnosisRequest) -> AiResult:
    vision_prompt = """
请作为羊肚菌图像识别专家分析图片。重点关注：
1. 羊肚菌长势、成熟度、菌盖和菌柄状态；
2. 是否存在白霉、蛛网状菌丝、腐烂、虫害、蛞蝓危害等风险；
3. 图片中可见的风险区域；
4. 农户需要立即检查的事项。

请用中文输出结构化诊断。
"""
    vision_answer = await ollama_client.generate(settings.vision_model, vision_prompt, [request.image_base64])
    query = f"{request.question or ''}\n{vision_answer}"
    references = knowledge_base.search(query, top_k=5)
    final_prompt = f"""
你是羊肚菌多专家建议生成专家。请融合图像识别结果、实时环境和知识库依据，输出最终诊断。

图像识别结果：
{vision_answer}

实时环境：
{environment_text(request.environment)}

知识库依据：
{reference_text(references)}

输出格式：
- 诊断结论：
- 风险等级：
- 主要依据：
- 建议操作：
- 需要人工复核：
"""
    answer = await ollama_client.generate(settings.text_model, final_prompt)
    return AiResult(
        answer=answer,
        diagnosis=vision_answer,
        risk_level=infer_risk_level(answer + vision_answer),
        actions=extract_actions(answer),
        references=references,
        expert_trace=["图像识别专家", "知识库检索专家", "环境数据分析专家", "建议生成专家"],
        raw={"vision": vision_answer},
    )
