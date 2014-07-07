var config = require('configure');
var sys = require('sys');
var exec = require('child_process').exec;

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
            sendSwitchCommand(data);
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

function sendSwitchCommand(model) {
    var cmd = config.switchExe.command + " " + model.systemCode + " " + model.deviceCode + " " + (model.status ? "1" : "0");
    for(var i=0;i<config.switchExe.trialCount;i++) {
        exec(cmd, log);
    }
}

function log(error, stdout, stderr) {
    console.log(stdout); }