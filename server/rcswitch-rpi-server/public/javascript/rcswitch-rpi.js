/**
 * Created by lars on 04.06.14.
 */
var socket = function($) {
    var socket = io.connect();

    socket.on('connect', function() {
        //console.log('connected');
        if (router)
            router.navigate('', { trigger:true });
    });

    socket.on('switches_response', function(modelList) {

    });

    socket.on('switch_changed', function(model) {
        $('.switch-btn[data-switch-id="'+model._id+'"]')
            .trigger('switchButton.setState', model.status);
    });

    return socket;
}(jQuery);

(function( $ ) {

    var defaults = {
        onStateChanged : null,
        label: {
            on: 'on',
            off: 'off'
        },
        styles: {
            on: 'btn-success',
            off: 'btn-danger',
            active: 'active'
        }
    }

    $.fn.switchButton = function(options) {

        return this.each( function() {
            var settings = $.extend( true, {}, defaults, options );
            var currentState = $(this).data('init-state') ? $(this).data('init-state') : false;

            setState($(this), currentState, settings);

            $(this).on('switchButton.setState', function(e, state) {
                currentState = state;
                setState($(this), currentState, settings);
            });

            $(this).on('click', function(event) {
                currentState = !currentState;
                setState($(this), currentState, settings);

                if ($.isFunction(options.onStateChanged)) {
                    options.onStateChanged($(this).data('switch-id'), currentState);
                }
            });
        });
    };

    function setState(button, state, settings) {
        button.removeClass(settings.styles.active);
        button.removeClass(settings.styles.on);
        button.removeClass(settings.styles.off);
        if (state) {
            button.addClass(settings.styles.on);
            button.addClass(settings.styles.active);
            button.html(settings.label.on);
        }
        else {
            button.addClass(settings.styles.off);
            button.html(settings.label.off);
        }
    }
}( jQuery ));

(function($) {
    $.fn.serializeObject = function() {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function() {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return o;
    };
}( jQuery ));

var RCSwitch = Backbone.Model.extend({
    idAttribute: "_id",
    urlRoot: '/rcswitches'
})

var RCSwitches = Backbone.Collection.extend({
    url:'/rcswitches',
    model: RCSwitch
});

var RCSwitchEditView = Backbone.View.extend({
    el:'.page',
    events: {
      'submit .edit-switch-form': 'saveSwitch',
      'click .delete': 'deleteSwitch'
    },
    saveSwitch : function(ev) {
        var that = this;
        var switchData = $(ev.currentTarget).serializeObject();
        var rcSwitch = new RCSwitch();
        rcSwitch.save(switchData, {
            success: function(switchModel) {
                socket.emit('switches_updated', switchModel);
                router.navigate('', { trigger: true });
            },
            error: function (switchModel, response) {
                var template = _.template($('#rcswitch-error-template').html(), { message: response.responseText});
                that.$el.html(template);
            }
        })
        return false;
    },
    deleteSwitch: function(ev) {
        var that = this;
        this.rcSwitch.destroy({
           success: function() {
               socket.emit('switches_updated', null);
               router.navigate('', { trigger:true });
           },
            error: function (switchModel, response) {
                var template = _.template($('#rcswitch-error-template').html(), { message: response.responseText});
                that.$el.html(template);
            }
        });
        return false;
    },
    render: function(options) {
        var that = this;
        if(options.id) {
            that.rcSwitch = new RCSwitch({_id: options.id});
            that.rcSwitch.fetch({
                success: function (rcSwitchModel, response) {
                    var template = _.template($('#edit-switch-template').html(), {switchModel: rcSwitchModel});
                    that.$el.html(template);

                },
                error: function (rcSwitchModel, response) {
                    var template = _.template($('#rcswitch-error-template').html(), { message: response.responseText});
                    that.$el.html(template);
                }
            });
        } else {
            var template = _.template($('#edit-switch-template').html(), {switchModel: null});
            this.$el.html(template);
        }
    }
});

var RCSwitchListView = Backbone.View.extend({
   el:'.page',

   render: function() {
       var that = this;
       var rcSwitches = new RCSwitches();
       rcSwitches.fetch({
           success: function(rcSwitches) {
               var template = _.template($('#rcswitch-list-template').html(), {rcSwitches: rcSwitches.models});
               that.$el.html(template);
               $('.switch-btn').switchButton({
                   onStateChanged: function(id, state) {
                       var rcSwitch = rcSwitches.get(id);
                       rcSwitch.set('status', state);
                       socket.emit('switch_changed', rcSwitch.attributes);
                   }
               });
           },
           error: function(rcSwitches, response) {
             var template = _.template($('#rcswitch-error-template').html(), { message: response.responseText});
               that.$el.html(template);
           }
       });
       return rcSwitches;
   }
});


var Router = Backbone.Router.extend({
    routes: {
        '' : 'index',
        'new': 'editSwitch',
        'rcswitch/:id': 'editSwitch'
    }
});

var rcSwitchEditView = new RCSwitchEditView();
var rcSwitchListView = new RCSwitchListView();

var router = new Router();

router.on('route:index', function() {
    rcSwitchListView.render();
});

router.on('route:editSwitch', function(id) {
    rcSwitchEditView.render({
        id: id
    });
});

Backbone.history.start();