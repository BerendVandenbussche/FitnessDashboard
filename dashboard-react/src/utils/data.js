const getWatchData = async function () {
  let data = await fetch(`http://192.168.0.191:8080/api/v1/watchdata`)
    .then(function (response) {
      if (!response.ok) {
        throw Error(`Probleem bij de fetch(). Status Code: ${response.status}`);
      } else {
        console.info('Er is een response teruggekomen van de server');
        return response.json();
      }
    })
    .catch(function (error) {
      console.error(`fout bij verwerken json ${error}`);
    });
  return data;
};

export{
    getWatchData
}
