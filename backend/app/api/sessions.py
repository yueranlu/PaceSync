# Main controller for run sessions: creating, joining, managing

from fastapi import APIRouter, HTTPException, Depends
import uuid
from LiveKit_Token import generate_token

from schemas.sessions_schema import (
    SessionCreate,
    SessionStatus,
    SessionJoin,
    SessionResponse,
    SessionJoinResponse,
    Participant,
    ErrorResponse,
)

router = APIRouter()

# Tempory in-memory store for sessions, connect real database later
sessions_db = {}

@router.post("/create", response_model=SessionResponse)
async def create_session(session: SessionCreate):
    session_id = str(uuid.uuid4()) # Generate a unique session ID

    session_data = {
        "session_id": session_id,
        "session_name": session.session_name,
        "description": session.description,
        "max_participants": session.max_participants,
        "status": SessionStatus.ACTIVE,
        "participants": [],
        "livekit_room": session.session_name,
    }

    sessions_db[session_id] = session_data
    return session_data

@router.post("/{session_id}/join", reponse_model=SessionJoinResponse)
async def join_session(session_id: str, join_data: SessionJoin):

    # Check if session exists
    if session_id not in sessions_db:
        raise HTTPException(status_code=404, detail="Session not found")

    session = sessions_db[session_id]
    user_id = str(uuid.uuid4()) # Unique user ID for each participant

    new_participant = Participant(
        user_id = user_id,
        display_name = join_data.display_name,
        pace = None,
        distance = 0.0,
        is_host = len(session["participants"]) == 0
    )

    # If session is full
    if len(session["participants"]) >= session["max_participants"]:
        raise HTTPException(status_code=400, detail="Session is full")
    
    session["participants"].append(new_participant.model_dump())
    sessions_db[session_id] = session

    participant_token = generate_token(identity=user_id, room_name=session["session_name"])

    return SessionJoinResponse(
        message = "Joined run",
        session = SessionResponse(**session),
        participants_info = new_participant,
        livekit_token = participant_token
    )

@router.get("/{session_id}", response_model=SessionResponse)
async def get_session(session_id: str):
    if session_id not in sessions_db:
        raise HTTPException(status_code=404, detail="Session not found")

    if sessions_db[session_id]["status"] != SessionStatus.ACTIVE:
        raise HTTPException(status_code=400, detail="Session is not active")
    
    return SessionResponse(**sessions_db[session_id])

