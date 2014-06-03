exports.events = {

    switches_get: function(io, socket, data) {
        console.log("SWITCHES GET");
        socket.emit("switches_response", [{"name":"test1", "description":"Dies ist ein test", "status":0},{"name":"test2", "description":"Dies ist noch ein test", "status":1}]);
    }
}