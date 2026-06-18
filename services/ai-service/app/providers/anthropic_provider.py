import anthropic
from .base import LLMProvider


class AnthropicProvider(LLMProvider):
    def __init__(self, api_key: str):
        self._client = anthropic.AsyncAnthropic(api_key=api_key)

    async def generate(self, prompt: str, system: str = "") -> str:
        msg = await self._client.messages.create(
            model="claude-haiku-4-5-20251001",
            max_tokens=1024,
            system=system or "You are a cricket commentary assistant.",
            messages=[{"role": "user", "content": prompt}],
        )
        return msg.content[0].text

    def health(self) -> dict:
        return {"provider": "anthropic", "status": "configured"}
