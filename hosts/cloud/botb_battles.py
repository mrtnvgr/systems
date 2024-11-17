#!/usr/bin/env python

# Simple script to notify me about new BotB battles

from requests.exceptions import RequestException, HTTPError
from datetime import datetime, timedelta
import requests, time

NTFY_TOPIC = "botb_upcoming_battles144"

def get_adjusted_time(x):
    x = datetime.fromisoformat(x)
    x += timedelta(hours=15) # Adjust to UTC+7
    return x

def ntfy_send(text):
    print(f"Sent: \"{text}\"")

    while True:
        try:
            requests.post(f"https://ntfy.sh/{NTFY_TOPIC}", data = text.encode(encoding="utf-8"))
            break
        except HTTPError as e:
            print(e.response.json())
        except RequestException as e:
            print(f"Error: {e}")
            time.sleep(600) # 10m

sent_battles = []
sent_battles_ids = set()

while True:
    battles = requests.get("https://battleofthebits.com/api/v1/battle/current").json()
    battles = [x for x in battles if x.get("period") == "warmup"]

    for battle in battles:
        if battle["id"] in sent_battles_ids:
            continue

        title = battle["title"]
        start_time = get_adjusted_time(battle["start"]).strftime("%H:%M %d.%m")

        ntfy_send(f"{title} ({start_time})")

        sent_battles.append(battle)
        sent_battles_ids.add(battle["id"])

    time.sleep(1500) # 25m

    # Collect garbage battles
    for battle in sent_battles:
        if datetime.now() > get_adjusted_time(battle["start"]):
            sent_battles.remove(battle)
            sent_battles_ids.remove(battle["id"])
