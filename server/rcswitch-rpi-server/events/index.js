exports.events = {

    switches_get: function(io, socket, data) {
        console.log("SWITCHES GET");
        socket.emit("switches_response", [{"id":"1", "name":"test1", "description":"Dies ist ein test", "status":false},{"id":"2", "name":"test2", "description":"Dies ist noch ein test", "status":true}]);
    },
    switch_changed: function(io, socket, data) {
        console.log("SWITCH CHANGED " + JSON.stringify(data));
        socket.broadcast.emit("switch_changed", data);
    }
}