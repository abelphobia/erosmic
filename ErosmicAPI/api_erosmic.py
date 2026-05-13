from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import httpx
import os

# Load .env
load_dotenv()

app = FastAPI()

# Allow Flutter connections
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Environment Variables ─────────────────────────────────────

# Used internally by FastAPI to talk to Jellyfin
JELLYFIN_INTERNAL_URL = os.environ.get(
    "JELLYFIN_INTERNAL_URL"
)

# Used by Flutter/emulator/device
JELLYFIN_PUBLIC_URL = os.environ.get(
    "JELLYFIN_PUBLIC_URL"
)

API_KEY = os.environ.get("JELLYFIN_API_KEY")
USER_ID = os.environ.get("JELLYFIN_USER_ID")

HEADERS = {
    "X-Emby-Token": API_KEY
}

# Debugging
print("INTERNAL:", JELLYFIN_INTERNAL_URL)
print("PUBLIC:", JELLYFIN_PUBLIC_URL)
print("USER:", USER_ID)

# ── Helpers ───────────────────────────────────────────────────

def build_track(item):
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

        # IMPORTANT:
        # Flutter needs PUBLIC URL
        "streamUrl":
            f"{JELLYFIN_PUBLIC_URL}"
            f"/Audio/{item['Id']}/stream"
            f"?static=true&api_key={API_KEY}",

        "albumArtUrl":
            f"{JELLYFIN_PUBLIC_URL}"
            f"/Items/{item['Id']}/Images/Primary"
            f"?api_key={API_KEY}",
    }

# ── Routes ────────────────────────────────────────────────────

@app.get("/")
async def root():
    return {"status": "running"}

@app.get("/tracks")
async def get_tracks():
    try:
        async with httpx.AsyncClient() as client:

            # IMPORTANT:
            # FastAPI talks to Jellyfin using INTERNAL URL
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

        print("JELLYFIN STATUS:", response.status_code)

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code,
                detail=response.text,
            )

        items = response.json().get("Items", [])

        return [build_track(item) for item in items]

    except Exception as e:
        print("TRACK ERROR:", e)
        raise HTTPException(
            status_code=500,
            detail=str(e),
        )

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

    return [
        {
            "id": item["Id"],
            "name": item["Name"],
        }
        for item in items
    ]
