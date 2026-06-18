from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file="../../.env", extra="ignore")

    ai_service_port: int = 8000
    anthropic_api_key: str = ""
    llm_provider: str = "anthropic"
    fallback_enabled: bool = True
    log_level: str = "info"


settings = Settings()
