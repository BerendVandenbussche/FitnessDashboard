import websockets
import asyncio
import json

time = 1
heartrate = 70
distance = 150
calories = 5
latitude = 2.6796
longitude = 53.7856

async def watchData(websocket, path):
    while True:
        await websocket.send(json.dumps({"time" : time, "heartrate": heartrate, "distance": distance, "calories": calories, "latitude": latitude, "longitude": longitude}))
        await asyncio.sleep(1)

start_server = websockets.serve(watchData, "", 9000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
