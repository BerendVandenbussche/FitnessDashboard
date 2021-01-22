import React, { useState, useEffect } from 'react';
import { getWatchData } from '../../utils/data';
import GoogleMap from 'google-map-react';

export function Map() {
  const [response, setResponse] = useState('');
  const [center, setCenter] = useState({});

  const mapStyles = {
    zIndex: 10,
    width: 100,
    height: 100,
  };

  const imgStyle = {
    height: '100%',
  };

  const markerStyle = {
    height: '50px',
    width: '50px',
  };

  const Marker = ({ title }) => (
    <div style={markerStyle}>
      <img style={imgStyle} src="/Assets/Location.png" alt={title} />
    </div>
  );

  const initializeWebsocket = () => {
    const ws = new WebSocket('ws://192.168.0.191:9000');
    ws.onmessage = function (event) {
      let data = JSON.parse(event.data);
      console.log(data);
      setResponse(data);
    };
  };

  useEffect(() => {
    (async () => {
      console.log(response);
      let initialData = await getWatchData();
      setCenter({ latitude: initialData.latitude, longitude: initialData.longitude });

      initializeWebsocket();
    })();
  }, []);

  return (
    <div className="App w-screen h-screen">
      <main className="h-10 w-10">
        <GoogleMap className="z-10" style={mapStyles} bootstrapURLKeys={{ key: 'AIzaSyA9Hsm7-IXipeU_5JVO3cGlUtUn4M_B0GU' }} center={{ lat: center.latitude, lng: center.longitude }} zoom={17}>
          <Marker title="Current location" lat={response.latitude} lng={response.longitude}></Marker>
        </GoogleMap>
      </main>
    </div>
  );
}
