from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

#API routers
from schemas.sessions_schema import ErrorResponse
from backend.app.api.sessions import router as sessions_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], #allows requests from any origin (device)
    allow_credentials=True, #allowing authentication information in requests
    allow_methods=["*"], #allows all HTTP request types (GET, POST, etc.)
    allow_headers=["*"],
)

#FastAPI method to include the API router
app.include_router(sessions_router, prefix="/sessions", tags=["sessions"])

app.get("/")
async def root():
    return {"message": "PaceSync is running!"}