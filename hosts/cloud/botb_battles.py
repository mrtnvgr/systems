# Simple script to notify me about new BotB battles

from datetime import datetime, timedelta
import requests, time

NTFY_TOPIC = "botb_upcoming_battles144"

def get_adjusted_time(x):
    x = datetime.fromisoformat(x)
    x += timedelta(hours=15) # Adjust to UTC+7
    return x

def ntfy_send(text):
    print(f"Sent: \"{text}\"")
    resp = requests.post(f"https://ntfy.sh/{NTFY_TOPIC}", data = text.encode(encoding="utf-8"))
    if resp.status_code != 200:
        print(resp.json())

sent_battles = []
sent_battles_ids = set()

while True:
    battles = requests.get("https://battleofthebits.com/api/v1/battle/current").json()
    battles = [x for x in battles if x["period"] == "warmup"]

    for battle in battles:
        if battle["id"] in sent_battles_ids:
            continue

        title = battle["title"]
        start_time = get_adjusted_time(battle["start"]).strftime("%H:%M %d.%m")

        ntfy_send(f"{title} ({start_time})")

        sent_battles.append(battle)
        sent_battles_ids.add(battle["id"])

    time.sleep(3600) # 1h

    # Collect garbage battles
    for battle in sent_battles:
        if get_adjusted_time(battle["start"]) > datetime.now():
            sent_battles.remove(battle)
            sent_battles_ids.remove(battle["id"])
