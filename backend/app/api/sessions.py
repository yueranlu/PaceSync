# Main controller for run sessions: creating, joining, managing

from fastapi import APIRouter, HTTPException, Depends
import uuid
from backend.app.api.LiveKit_Token import generate_token

from schemas.sessions_schema import (
    SessionCreate,
    SessionStatus,
    SessionJoin,
    SessionResponse,
    SessionJoinResponse,
    ErrorResponse,
)

router = APIRouter()

# Tempory in-memory store for sessions, connect real database later
sessions_db = {}

@router.post("/create", response_model=SessionResponse)
async def create_session(session: SessionCreate):
    session_id = str(uuid.uuid4()) # Generate a unique session ID
    livekit_token = generate_token(identity=session_id, room_name=session.session_name)
    # livekit_token = "temporary token"

    session_data = {
        "session_id": session_id,
        "session_name": session.session_name,
        "description": session.description,
        "max_participants": session.max_participants,
        "status": SessionStatus.ACTIVE,
        "participants": [],
        "livekit_token": livekit_token,
        "livekit_room": session.session_name,
    }

    sessions_db[session_id] = session_data
    return session_data

@router.post("/join", response_model=SessionJoinResponse)
async def join_session(session: SessionJoin):
    # Implementation for joining a session
    pass
