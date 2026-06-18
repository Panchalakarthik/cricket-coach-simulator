from .base import LLMProvider
from .anthropic_provider import AnthropicProvider
from .fallback_provider import FallbackProvider
from ..config import settings


def get_provider() -> LLMProvider:
    if settings.llm_provider == "anthropic" and settings.anthropic_api_key:
        return AnthropicProvider(api_key=settings.anthropic_api_key)
    if settings.fallback_enabled:
        return FallbackProvider()
    raise RuntimeError("No LLM provider configured and fallback is disabled")
