from app.knowledge_base import knowledge_base
from app.ollama_client import ollama_client
from app.schemas import AiResult, ChatRequest, EnvironmentSnapshot, ReferenceChunk, VisionDiagnosisRequest
from app.settings import settings


def environment_text(environment: EnvironmentSnapshot | None) -> str:
    if not environment:
        return "未提供大棚实时环境数据。"

    air_temperature = environment.air_temperature if environment.air_temperature is not None else environment.temperature
    air_humidity = environment.air_humidity if environment.air_humidity is not None else environment.humidity
    soil_humidity = environment.soil_humidity if environment.soil_humidity is not None else environment.soil_moisture

    return (
        f"大棚：{environment.greenhouse_name or environment.greenhouse_id or '-'}；"
        f"空气温度：{air_temperature if air_temperature is not None else '-'}℃；"
        f"空气湿度：{air_humidity if air_humidity is not None else '-'}%；"
        f"土壤温度：{environment.soil_temperature if environment.soil_temperature is not None else '-'}℃；"
        f"土壤湿度：{soil_humidity if soil_humidity is not None else '-'}%；"
        f"pH值：{environment.ph_value if environment.ph_value is not None else '-'}；"
        f"CO2：{environment.co2_ppm if environment.co2_ppm is not None else '-'}ppm；"
        f"光照强度：{environment.light_lux if environment.light_lux is not None else '-'}lux。"
    )


def reference_text(references: list[ReferenceChunk]) -> str:
    if not references:
        return "本次知识库未检索到直接相关片段。请改用大模型通用农技知识回答，并明确说明该结论不是知识库原文引用。"
    lines = []
    for index, ref in enumerate(references, start=1):
        lines.append(f"[{index}] {ref.source} 第{ref.page or '-'}页：{ref.content}")
    return "\n".join(lines)


def infer_risk_level(text: str) -> str:
    severe_words = ["严重", "高风险", "立即", "大量", "腐烂", "虫害", "病害", "白霉", "蛛网", "螨"]
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
    mode_instruction = (
        "知识库已命中相关片段。请优先依据知识库内容回答；如需要补充常识，请区分“知识库依据”和“通用农技判断”。"
        if references
        else "知识库未命中相关片段。仍然必须调用并使用大模型自身的通用农技知识回答，不要直接拒答；请在回答开头标注“未检索到知识库依据，以下为通用农技建议”。"
    )
    prompt = f"""
你是羊肚菌智慧大棚专业 AI 助手。请根据用户问题、实时环境数据和可用知识库内容回答。

当前回答模式：{mode_instruction}

要求：
1. 使用中文回答，直接、专业、可执行。
2. 知识库没有命中时，也要基于羊肚菌种植常识给出阶段划分、判断逻辑和操作建议。
3. 不确定的结论要提示需要人工复核，但不能只说“咨询专家”就结束。
4. 不要伪造“某文件/某标准第几条”等不存在的知识库引用。
5. 涉及环境调控时，结合空气温湿度、土壤温湿度、pH、CO2、光照强度七项数据说明。

用户问题：{request.question}

实时环境：
{environment_text(request.environment)}

知识库依据：
{reference_text(references)}
"""
    answer = await ollama_client.generate(settings.text_model, prompt)
    return AiResult(
        answer=answer,
        risk_level=infer_risk_level(answer),
        actions=extract_actions(answer),
        references=references,
        expert_trace=["知识库检索专家", "环境数据分析专家", "Ollama文本问答专家", "建议生成专家"],
        raw={"answer_mode": "rag" if references else "ollama_fallback", "model": settings.text_model},
    )


async def vision_diagnosis(request: VisionDiagnosisRequest) -> AiResult:
    vision_prompt = """
请作为羊肚菌图像识别专家分析图片。重点关注：
1. 羊肚菌长势、成熟度、菌盖和菌柄状态；
2. 是否存在白霉、蛛网状菌丝、腐烂、虫害、螨虫危害等风险；
3. 图片中可见的风险区域；
4. 农户需要立即检查的事项。
请用中文输出结构化诊断。"""
    vision_answer = await ollama_client.generate(settings.vision_model, vision_prompt, [request.image_base64])
    query = f"{request.question or ''}\n{vision_answer}"
    references = knowledge_base.search(query, top_k=5)
    mode_instruction = (
        "知识库已命中相关片段，请结合图像识别结果和知识库依据输出。"
        if references
        else "知识库未命中相关片段，请基于图像模型结果和大模型通用农技知识输出，不要直接拒答。"
    )
    final_prompt = f"""
你是羊肚菌多专家建议生成专家。请融合图像识别结果、实时环境和知识库依据，输出最终诊断。

当前回答模式：{mode_instruction}

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
        expert_trace=["图像识别专家", "知识库检索专家", "环境数据分析专家", "Ollama建议生成专家"],
        raw={"vision": vision_answer, "answer_mode": "rag" if references else "ollama_fallback", "model": settings.text_model},
    )
