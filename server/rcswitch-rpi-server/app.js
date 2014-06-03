/**
 * Module dependencies.
 */

var express = require('express'), app = express();
var http = require('http'),
    server = http.createServer(app),
    io = require('socket.io').listen(server);
var mdns = require('mdns2');
var path = require('path');
var routes = require('./routes');
var config = require('configure');

// all environments
app.set('port', process.env.PORT || config.webserver.port || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
    app.use(express.errorHandler());
}

app.get('/', routes.index); // Route to ember.js client view

// register all socket.io event handler
var eventHandlers = require('./events').events;

io.sockets.on('connection', function (socket) {
    for(eventname in eventHandlers) {
        (function(currentevent) {
            socket.on(currentevent, function(data) {
                eventHandlers[currentevent](io, socket, data);
            })
        })(eventname);
    }
});

// Start Server
server.listen(app.get('port'), function () {
    console.log('rcswitch-rpi-server: listening on port ' + app.get('port'));
});

// Start Bonjour Service
mdns.createAdvertisement(mdns.tcp('http'), app.get('port'), {
        name: config.webserver.serviceName,
        txtRecord: {
                name: config.serviceName,
                author: config.author
}}).start();
