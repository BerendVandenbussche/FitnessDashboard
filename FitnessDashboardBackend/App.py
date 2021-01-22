# -*- coding: utf-8 -*-

from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_socketio import SocketIO, send, emit
import websockets
import asyncio
import json
from threading import Thread


app = Flask(__name__)
CORS(app)
socketio = SocketIO(app)
endpoint = "/api/v1"

connected = False
time = None
heartrate = None
distance = None
calories = None
latitude = None
longitude = None

@app.route(endpoint + "/watchdata", methods=["GET"])
def get_watch_data():
    if request.method == "GET":
        return {"time" : time, "heartrate": heartrate, "distance": distance, "calories": calories, "latitude": latitude, "longitude": longitude, "connected": connected}


async def watchData(websocket, path):
    while True:
        await websocket.send(json.dumps({"time" : time, "heartrate": heartrate, "distance": distance, "calories": calories, "latitude": latitude, "longitude": longitude, "connected": connected}))
        await asyncio.sleep(1)


def start_loop(loop, server):
    loop.run_until_complete(server)
    loop.run_forever()

# start a new event loop
new_loop = asyncio.new_event_loop()
start_server = websockets.serve(watchData, "", 9000, loop=new_loop)
t = Thread(target=start_loop, args=(new_loop, start_server))
t.start()



@socketio.on("connect")
def connected():
    global connected
    connected = True
    print("Client connected")


@socketio.on("disconnect")
def disconnected():
    global connected
    connected = False
    print("Client disconnected")


@socketio.on("watchData")
def get_realtime_data(data):
    global time, heartrate, distance, calories, latitude, longitude
    print(data)
    time = data["time"]
    heartrate = data["heartrate"]
    distance = data["distance"]
    calories = data["calories"]
    latitude = float(data["latitude"])
    longitude = float(data["longitude"])
    print("You burned %s calories with %s time of running and a distance of %s. Your current heartrate is %s BPM, you are located at %s %s" %(calories,time, distance, heartrate, latitude, longitude))



if __name__ == '__main__':
    socketio.run(app, host="0.0.0.0", port=8080)