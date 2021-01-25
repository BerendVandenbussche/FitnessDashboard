import './App.css';
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import { Map } from './Presentations/Views/Map';
import { ionicon } from 'ionicons';

function App() {
  const [response, setResponse] = useState('');

  const initializeWebsocket = () => {
    const ws = new WebSocket('ws://192.168.0.191:9000');
    ws.onmessage = function (event) {
      let data = JSON.parse(event.data);
      console.log(data);
      setResponse(data);
    };
  };

  useEffect(() => {
    initializeWebsocket();
  }, []);

  return (
    <div className="App w-screen h-screen flex justify-center items-center">
      <Router>
        <main className="w-auto lg:w-1/2 h-auto bg-red-500 p-5 text-left rounded-lg">
          <div className="lg:grid block grid-cols-2 grid-rows-1 w-full">
            <div className="w-max">
              <h1 className="text-white text-4xl font-bold pb-4">Fitness Dashboard</h1>
              <p className="text-white text-lg">Time: {response.time}</p>
              <p className="text-white text-lg">Active calories: {response.calories} cal</p>
              <p className="text-white text-lg">Heartrate: {response.heartrate} BPM</p>
              <p className="text-white text-lg">
                Distance: {response.distance >= 1000 ? response.distance / 1000 : response.distance} {response.distance >= 1000 ? 'km' : 'm'}
              </p>
            </div>
            {response.connected ? (
              <div></div>
            ) : (
              <div className="w-full h-full flex flex-col justify-center items-center mt-5 lg:mt-0">
                <h3 className="text-white text-9xl">⚠️</h3>
                <h3 className="text-white text-lg">Apple watch is not connected</h3>
              </div>
            )}
          </div>

          <Link to="/map">
            <div className="w-auto h-auto bg-white flex justify-center items-center p-2 rounded-full mt-10">
              <p>Live location data</p>
              <ionicon name="navigate-outline" color="black"></ionicon>
            </div>
          </Link>
        </main>
        <Switch>
          <Route path="/map">
            <Map />
          </Route>
        </Switch>
      </Router>
    </div>
  );
}

export default App;
