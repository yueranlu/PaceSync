import os
from livekit import api
from dotenv import load_dotenv

load_dotenv('.env.livekit')

def generate_token(identity, room_name):
    token = api.AccessToken(os.getenv('LIVEKIT_API_KEY'), os.getenv('LIVEKIT_API_SECRET')) \
        .with_identity(identity) \
        .with_name(room_name) \
        .with_grants(api.VideoGrants(
            room_join=True,
            room=room_name,
        ))
    
    return token.to_jwt()

