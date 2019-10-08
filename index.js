const app = Elm.Main.init({
  node: document.getElementById('elm-node')
});

app.ports.requestLocation.subscribe(() => {
  const successCallback = (position) => {
    if (!!position && !!position.coords) {
      const result = {
        status: "OK",
        location: {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        }
      };
      app.ports.receiveLocation.send(JSON.stringify(result));
    } else {
      const result = {
        status: "ERROR"
      };
      app.ports.receiveLocation.send(JSON.stringify(result));
    }
  };

  const errorCallback = (error) => {
    console.log(error);
    const result = {
      status: "ERROR"
    };
    console.log(JSON.stringify(result));
    app.ports.receiveLocation.send(JSON.stringify(result));
  };

  const options = {
    enableHighAccuracy: false,
    maximumAge: 0,
    timeout: 3000
  };

  navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options);
});