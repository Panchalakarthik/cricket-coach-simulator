from fastapi import FastAPI
from .routers import health

app = FastAPI(title="Cricket Coach AI Service", version="beta-v1")

app.include_router(health.router)
app.include_router(health.router, prefix="/api/v1")
