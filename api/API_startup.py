from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
import httpx
import os

app = FastAPI()

# Allow Flutter app to talk to this server
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# info from environment variables
JELLYFIN_URL = os.environ.get("JELLYFIN_URL")  # e.g. "http://localhost:8096"
API_KEY      = os.environ.get("JELLYFIN_API_KEY")
USER_ID      = os.environ.get("JELLYFIN_USER_ID")


HEADERS = {"X-Emby-Token": API_KEY}


@app.get("/tracks")
async def get_tracks():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_URL}/Users/{USER_ID}/Items",
            headers=HEADERS,
            params={
                "IncludeItemTypes": "Audio",
                "Recursive": True,
                "Fields": "MediaSources,Genres,RunTimeTicks",
            },
        )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch tracks")

    items = response.json().get("Items", [])
    return [
        {
            "id":          item["Id"],
            "title":       item.get("Name", "Unknown"),
            "artist":      item.get("AlbumArtist", "Unknown"),
            "album":       item.get("Album", "Unknown"),
            "genre":       item.get("Genres", ["Unknown"])[0] if item.get("Genres") else "Unknown",
            "duration":    (item.get("RunTimeTicks", 0) or 0) // 10000000,
            "streamUrl":   f"{JELLYFIN_URL}/Audio/{item['Id']}/stream?static=true&api_key={API_KEY}",
            "albumArtUrl": f"{JELLYFIN_URL}/Items/{item['Id']}/Images/Primary?api_key={API_KEY}",
        }
        for item in items
    ]


@app.get("/genres")
async def get_genres():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_URL}/MusicGenres",
            headers=HEADERS,
            params={"UserId": USER_ID},
        )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch genres")

    items = response.json().get("Items", [])
    return [item["Name"] for item in items]


@app.get("/albums")
async def get_albums():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_URL}/Users/{USER_ID}/Items",
            headers=HEADERS,
            params={
                "IncludeItemTypes": "MusicAlbum",
                "Recursive": True,
            },
        )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch albums")

    items = response.json().get("Items", [])
    return [{"id": item["Id"], "name": item["Name"]} for item in items]


@app.get("/albums/{album_id}/tracks")
async def get_album_tracks(album_id: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_URL}/Users/{USER_ID}/Items",
            headers=HEADERS,
            params={
                "IncludeItemTypes": "Audio",
                "Recursive": True,
                "ParentId": album_id,
                "Fields": "MediaSources,Genres,RunTimeTicks",
            },
        )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch album tracks")

    items = response.json().get("Items", [])
    return [
        {
            "id":          item["Id"],
            "title":       item.get("Name", "Unknown"),
            "artist":      item.get("AlbumArtist", "Unknown"),
            "album":       item.get("Album", "Unknown"),
            "genre":       item.get("Genres", ["Unknown"])[0] if item.get("Genres") else "Unknown",
            "duration":    (item.get("RunTimeTicks", 0) or 0) // 10000000,
            "streamUrl":   f"{JELLYFIN_URL}/Audio/{item['Id']}/stream?static=true&api_key={API_KEY}",
            "albumArtUrl": f"{JELLYFIN_URL}/Items/{item['Id']}/Images/Primary?api_key={API_KEY}",
        }
        for item in items
    ]


@app.get("/genres/{genre}/tracks")
async def get_genre_tracks(genre: str):
    async with httpx.AsyncClient() as client:
        response = await client.get(
            f"{JELLYFIN_URL}/Users/{USER_ID}/Items",
            headers=HEADERS,
            params={
                "IncludeItemTypes": "Audio",
                "Recursive": True,
                "Genres": genre,
                "Fields": "MediaSources,Genres,RunTimeTicks",
            },
        )
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="Failed to fetch genre tracks")

    items = response.json().get("Items", [])
    return [
        {
            "id":          item["Id"],
            "title":       item.get("Name", "Unknown"),
            "artist":      item.get("AlbumArtist", "Unknown"),
            "album":       item.get("Album", "Unknown"),
            "genre":       item.get("Genres", ["Unknown"])[0] if item.get("Genres") else "Unknown",
            "duration":    (item.get("RunTimeTicks", 0) or 0) // 10000000,
            "streamUrl":   f"{JELLYFIN_URL}/Audio/{item['Id']}/stream?static=true&api_key={API_KEY}",
            "albumArtUrl": f"{JELLYFIN_URL}/Items/{item['Id']}/Images/Primary?api_key={API_KEY}",
        }
        for item in items
    ]