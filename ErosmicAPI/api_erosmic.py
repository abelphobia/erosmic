from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import httpx
import os

# This loads the environment variables from the .env file stored onto my computer.
load_dotenv()

# FastApi is the framework that is being used on this project.
app = FastAPI()

# Allow Flutter to request cross-origin resources from this API. meaning this allows flutter to connect from any device. 
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Environment variables 
# Used internally by FastAPI to talk to Jellyfin
JELLYFIN_INTERNAL_URL = os.environ.get(
    "JELLYFIN_INTERNAL_URL"
)
# Used by Flutter/emulator/device
JELLYFIN_PUBLIC_URL = os.environ.get(
    "JELLYFIN_PUBLIC_URL"
)
# API key and user ID for authentication and is used to gather data from the server.
API_KEY = os.environ.get("JELLYFIN_API_KEY")
USER_ID = os.environ.get("JELLYFIN_USER_ID")

HEADERS = {
    "X-Emby-Token": API_KEY # Key authentication to access the Emby Server API, assisted by jellyfin.
}

# Helpers Section - this is where the information given is defined from the server.

# defines the item then returns an id and title, artist, album, genre, duration, streamUrl, and albumArtUrl.
def build_track(item): # if the items provided does not have the information, its listed as unknown.
    return {
        "id": item.get("Id"),
        "title": item.get("Name", "Unknown"),
        "artist": item.get(
            "AlbumArtist",
            "Unknown"
        ),
        "album": item.get(
            "Album",
            "Unknown"
        ),
        "genre": (
            item.get("Genres", ["Unknown"])[0]
            if item.get("Genres")
            else "Unknown"
        ),
        "duration": (
            item.get("RunTimeTicks", 0) or 0
        ) // 10000000,

        # StreamUrl sets the URL from the audio and sets the images for the album art. 
        "streamUrl":
            f"{JELLYFIN_PUBLIC_URL}"
            f"/Audio/{item['Id']}/stream"
            f"?static=true&api_key={API_KEY}",

        "albumArtUrl":
            f"{JELLYFIN_PUBLIC_URL}"
            f"/Items/{item['Id']}/Images/Primary"
            f"?api_key={API_KEY}",
    }

# Routes Section - this is where the API get defined and placed onto the app.
# @app.get routes the handler to specific URL path from HTTP GET requests. 

@app.get("/")
async def root():
    return {"status": "running"}

@app.get("/tracks")
async def get_tracks(): # Allows the request coming from FastAPI to run in a asynchronous time.
    try: 
        async with httpx.AsyncClient() as client:
            # response allows the FastAPI to wait for a response before being executed. 
            response = await client.get(
                f"{JELLYFIN_INTERNAL_URL}/Users/{USER_ID}/Items",
                headers=HEADERS,
                params={
                    "IncludeItemTypes": "Audio",
                    "Recursive": True,
                    "Fields":
                        "MediaSources,"
                        "Genres,"
                        "RunTimeTicks",
                },
            )

        print("JELLYFIN STATUS:", response.status_code) # provides status code once executed. duh.

        if response.status_code != 200: # a 200 response code indicates that the code is working properly.
            raise HTTPException(
                status_code=response.status_code,
                detail=response.text,
            )

        items = response.json().get("Items", []) # Jellyfins responds in JSON to the list in "items", [] if there are no items on the list.
        # executes in items name in items.
        return [build_track(item) for item in items]
# any other errors will be defined on the terminal.
    except Exception as e:
        print("TRACK ERROR:", e)
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )
# Gets genres
@app.get("/genres")
async def get_genres():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_INTERNAL_URL}/MusicGenres",
            headers=HEADERS,
            params={"UserId": USER_ID},
        )

    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail="Failed to fetch genres",
        )

    items = response.json().get("Items", []) 
    return [item["Name"] for item in items] 

# Gets albums 
@app.get("/albums")
async def get_albums():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_INTERNAL_URL}/Users/{USER_ID}/Items",
            headers=HEADERS,
            params={
                "IncludeItemTypes": "MusicAlbum",
                "Recursive": True,
            },
        )

    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail="Failed to fetch albums",
        )

    items = response.json().get("Items", [])
    # provides the id and name of each album.
    return [
        {
            "id": item["Id"],
            "name": item["Name"],
        }
        for item in items
    ]
