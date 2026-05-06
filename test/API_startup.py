import requests
import json 

response = requests.get("https://api.jellyfin.org/#tag/Artists")


print(f"Response JSON: {response.json()}")