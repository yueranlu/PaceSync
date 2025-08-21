from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

#API routers
from schemas.sessions_schema import ErrorResponse

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], #allows requests from any origin (device)
    allow_credentials=True, #allowing authentication information in requests
    allow_methods=["*"], #allows all HTTP request types (GET, POST, etc.)
    allow_headers=["*"],
)

app.get("/")
async def root():
    return {"message": "PaceSync is running!"}