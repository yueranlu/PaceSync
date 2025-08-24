from sqlalchemy import Column, String, DateTime
from ..database import Base
import datetime

class User(Base):
    __tablename__ = "users"

    firebase_uid = Column(String, primary_key=True, index=True)
    display_name = Column(String(100), nullable=True)
    email = Column(String(150), nullable=True)
    photo_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
