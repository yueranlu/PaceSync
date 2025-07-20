from fastapi import FastAPI
from pydantic import BaseModel
import spotipy
from spotipy.oauth2 import SpotifyOAuth

class Song(BaseModel):
    name: str
    length: int
    artist: str
    id: str

app = FastAPI()

sp = spotipy.Spotify(auth_manager = SpotifyOAuth(client_id="b55d399d11934dfc9cc4941ef3d40e2b",
                                                 client_secret="56cf7f92503942a8bcca70b53de6675b",
                                                 redirect_uri="pacesync-login://callback",
                                                 scope="user-top-read")) #apparently this is needed for recommendations

track_history = []

#global function that finds a suitable track for the bpm and genre
def bpm_to_song(current_tempo: int, genre: List[str]) -> Song: #global function allows code reusability
    recommendations = sp.recommendations(
        seed_genres = genre, #users select desired genre, can have multiple as well
        target_tempo = current_tempo, #this will be given by pace-to-BPM code
        min_tempo = current_tempo - 5,
        max_tempo = current_tempo + 5,
        limit = 1
    )

    if not recommendations['tracks']:
        return {"message": "Track does not exist"}

    current_track = recommendations["tracks"][0] #get first track only amongst all recs
    current_artist = [a['name'] for a in current_track['artists']] #displays only the name of the current artist

    return Song(name = current_track['name'], artists = current_artist, id = current_track['id'])


@app.get("/recommendations") #path to recs
async def track_rec():
    current_track = bpm_to_song(current_tempo, genre)
    current_artist = current_artist = [a['name'] for a in current_track['artists']]

    return Song(name = current_track['name'], artists = current_artist, id = current_track['id'])


@app.post("/history")
async def add_history():
    current_track = bpm_to_song(current_tempo, genre)
    current_artist = [a['name'] for a in current_track['artists']]

    #add to history
    track_history.append({
        'name': current_track['name'],
        'artists': current_artist,
        'id': current_track['id']
    })

    return {"message": "Successfully added track to the history", "track": current_track['name']}


@app.get("/history")
async def get_history(limit: int = 15):
    if not track_history:
        return {"message": "Nothing to see here. Start listening!"}

    return track_history[-limit:]