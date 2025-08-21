from pydantic import BaseModel, Field, field_validator
from typing import Optional
from enum import Enum

class SessionStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

# Schema for the creation of a new run session
class SessionCreate(BaseModel):
    session_name: str = Field(..., min_length=1, max_length=100, description="Name of the run session")
    description: Optional[str] = Field(None, max_length=500, description="Optional description of run session")
    max_participants: int = Field(default=6, ge=2, le=100, description="Maximum nnumber of users in run session")
    # add more fields when data availalbe (host name, id)

    @field_validator("session_name")
    def validate_session_name(cls, value):
        if not value.strip():
            raise ValueError("Session name cannot be empty or whitespace")
        return value
    
    @field_validator("description")
    def validate_description(cls, value):
        if value is not None:
            return value.strip() if value.strip() else None
        return value

class SessionJoin(BaseModel):
    display_name: str = Field(..., min_length=1, max_length=50, description="Display name of the user joining the session")

class Participant(BaseModel):
    user_id: str
    display_name: Optional[str] = None
    pace: Optional[float] = None
    distance: float = 0.0
    is_host: bool = False

    # location to be added later 
    
class SessionResponse(BaseModel):
    session_id: str
    session_name: str
    description: Optional[str] = None
    status: SessionStatus = SessionStatus.ACTIVE
    max_participants: int = 6
    participants: list[Participant] = []

    livekit_token: str = Field(..., description="LiveKit token for the session")
    livekit_room: str = Field(..., description="LiveKit room name for the session")
    
    class Config:
        orm_mode = True  # Enable ORM mode for compatibility with ORMs like SQLAlchemy

class SessionJoinReponse(BaseModel):
    message: str = "Joined run"
    session: SessionResponse
    participants_info: Participant

class ErrorResponse(BaseModel):
    error: str
    detail: Optional[str] = None
    error_code: Optional[int] = None

class SuccessResponse(BaseModel):
    message: str
    success: bool = True



