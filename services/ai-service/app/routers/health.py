from datetime import datetime, timezone
from fastapi import APIRouter
from ..providers.factory import get_provider

router = APIRouter()


@router.get("/health")
async def health():
    provider = get_provider()
    return {
        "status": "ok",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "provider": provider.health(),
    }
