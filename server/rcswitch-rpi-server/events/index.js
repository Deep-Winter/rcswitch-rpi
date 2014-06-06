exports.events = {

    switches_get: function(io, socket, data, db) {
        db.switches.find({}, function(err, result) {

            if (err) {
                console.log(err);
                return;
            }

            socket.emit("switches_response", result);
        });
        //socket.emit("switches_response", [{"id":"1", "name":"test1", "description":"Dies ist ein test", "status":false},{"id":"2", "name":"test2", "description":"Dies ist noch ein test", "status":true}]);
    },
    switch_changed: function(io, socket, data, db) {
        db.switches.update({_id: data._id}, data, {}, function(err, numReplace, upsert) {
           if (err) {
               console.log(err);
               return;
           }
            socket.broadcast.emit("switch_changed", data);
            db.switches.persistence.compactDatafile();
        });
    },
    switches_updated: function(io, socket, data, db) {
        db.switches.find({}, function(err, result) {

            if (err) {
                console.log(err);
                return;
            }

            socket.broadcast.emit("switches_response", result);
        });
    }
}