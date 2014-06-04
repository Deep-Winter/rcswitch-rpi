/**
 * Created by lars on 04.06.14.
 */
var socket = function($) {
    var socket = io.connect();

    socket.on('connect', function() {
        console.log('connected');
    });

    socket.on('switches_response', function(modelList) {
        var panel = $('#button-panel');
        modelList.forEach(function(model, index) {
            panel.append('<div class="button-panel" id="button-panel-'+model.id+'" class="buttonPanel"><div class="btn-group" data-toggle="buttons"><label id="switch-on-'+model.id+'" class="btn btn-default '+(model.status ? 'active' : '')+'"><input '
            +(model.status ? 'checked' : '')+ ' type="radio" name="options" id="option-true-'
                +model.id+'">an</label><label id="switch-off-'+model.id+'" class="btn btn-default '+(model.status ? '' : 'active')+'"><input '
                +(model.status ? '' : 'checked')+
                ' type="radio" name="options" id="option-false-'+model.id+'">aus</label></div><span class="button-name">'+model.name+'</span></div>');
        });
    });

    socket.on('switch_changed', function(model) {
        var switchOn = $('#switch-on-' + model.id);
        var switchOff = $('#switch-off-' + model.id);
        if (model.status) {
            switchOn.addClass('active');
            switchOn.removeClass('btn-default');
            switchOn.addClass('btn-success');
            switchOff.removeClass('active');
            switchOff.removeClass('btn-danger');
            switchOff.addClass('btn-default');
        }
        else {
            switchOn.removeClass('active');
            switchOn.removeClass('btn-success');
            switchOn.addClass('btn-default');
            switchOff.addClass('active');
            switchOff.removeClass('btn-default');
            switchOff.addClass('btn-danger');

        }
    });

    return socket;
}(jQuery);

var RCSwitches = Backbone.Collection.extend({
   url:'/rcswitches'
});

var RCSwitchList = Backbone.View.extend({
   el:'.page',
   render: function() {
       var that = this;
       var rcswitches = new RCSwitches();
       rcswitches.fetch({
           success: function(rcswitches) {
               var template = _.template($('#rcswitch-list-template').html(), {rcswitches: rcswitches.models});
               that.$el.html(template);
           },
           error: function(rcswitches, response) {
             var template = _.template($('#rcswitch-error-template').html(), { message: response.responseText});
               that.$el.html(template);
           }
       })

   }
});

var Router = Backbone.Router.extend({
    routes: {
        '' : 'index'
    }
});

var rcswitchList = new RCSwitchList();
var router = new Router();
router.on('route:index', function() {
    rcswitchList.render();
});

Backbone.history.start();