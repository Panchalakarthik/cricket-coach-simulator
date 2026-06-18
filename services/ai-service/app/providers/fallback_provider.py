from .base import LLMProvider


class FallbackProvider(LLMProvider):
    """Returns deterministic placeholder responses when no LLM provider is available."""

    async def generate(self, prompt: str, system: str = "") -> str:
        return "Commentary not available at this time."

    def health(self) -> dict:
        return {"provider": "fallback", "status": "ok"}
