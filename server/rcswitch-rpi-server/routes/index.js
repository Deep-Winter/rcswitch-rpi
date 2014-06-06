/*
 * GET home page.
 */

var db;

exports.setDB = function(theDB) {
    db = theDB;
};

exports.index = function (req, res, db) {

    res.render('index', { title: 'medo.check sever' });
};

exports.rcswitches = function(req, res) {
    db.switches.find({}, function(err, result) {

        if (err) {
            console.log(err);
            res.status(500).json(null);
            return;
        }
        res.json(result);
    });
};

exports.getSwitch = function(req, res) {
    var id = req.params.id;
    db.switches.find({ _id : id}, function(err, result) {

        if (err) {
            console.log(err);
            res.status(500).json(null);
            return;
        }
        res.json(result[0]);
    });
};

exports.insertSwitch = function(req, res) {
    var doc = req.body;

    db.switches.insert(doc, function(err, result) {
        if (err) {
            console.log(err);
            res.status(500).json(doc);
            return;
        }

        res.json(result);
    });
};

exports.updateSwitch = function(req, res){

    var id = req.params.id;
    var model = req.body;

    db.switches.update({ _id: id}, model, {}, function(err, numReplace, upsert) {

        if (err) {
            console.log(err);
            res.status(500).json(null);
            return;
        }

        db.switches.persistence.compactDatafile();
        res.json(model);
    });
};

exports.deleteSwitch = function(req, res) {

    var id = req.params.id;

    db.switches.remove({ _id: id}, function(err, numRemoved) {

        if (err) {
            console.log(err);
            res.status(500).json(null);
            return;
        }
        db.switches.persistence.compactDatafile();
        res.json(null);
    });
}