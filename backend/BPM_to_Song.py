from fastapi import FastAPI
from pydantic import BaseModel
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import os

# class Song(BaseModel):
#     name: str
#     artist: str
#     id: str

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Server is working"}

sp = spotipy.Spotify(auth_manager = SpotifyOAuth(
    client_id=os.getenv("SPOTIFY_CLIENT_ID", "b55d399d11934dfc9cc4941ef3d40e2b"),
    client_secret=os.getenv("SPOTIFY_CLIENT_SECRET", "56cf7f92503942a8bcca70b53de6675b"),
    redirect_uri="pacesync-login://callback",
    scope=""
))

songs = []
track_history = []

#global function that finds a suitable track for the bpm and genre
def bpm_to_song(current_tempo, genre): #global function allows code reusability
    # current_track = recommendations["tracks"][0] #get first track onsly amongst all recs
    # current_artist = current_track['artists'][0]['name'] #displays only the name of the current artist

    try:
        recommendations = sp.recommendations(
            seed_genres = [genre], #users select desired genre, can have multiple as well
            target_tempo = current_tempo, #this will be given by pace-to-BPM code
            min_tempo = current_tempo - 15,
            max_tempo = current_tempo + 15,
            limit = 1
        )
        # return Song(name = current_track['name'], artists = current_artist, id = current_track['id'])
        return [track['id'] for track in recommendations['tracks']]
    
    except spotipy.exceptions.SpotifyException as e:
        print(f"Error fetching recommendations: {e}")
        return []



@app.post("/recommendations") #path to recs
async def track_rec():
    current_track = bpm_to_song(110, "pop")

    songs.append(current_track)

    return current_track


@app.post("/history")
async def add_history():
    current_track = bpm_to_song(110, "pop")

    #add to history
    track_history.append({
        'name': current_track['name'],
        'artists': current_track['artist'],
        'id': current_track['id']
    })

    return {"message": "Successfully added track to the history", "track": current_track['name']}


@app.get("/history") 
# , response_model=list[Song])
async def get_history(limit: int = 15):
    if not track_history:
        return {"message": "Nothing to see here. Start listening!"}

    return track_history[-limit:]

seed_tracks = ['0cGG2EouYCEEC3xfa0tDFV', '7lQ8MOhq6IN2w8EYcFNSUk']
seed_genres = ['pop']
print(bpm_to_song(seed_tracks, seed_genres))