var Q = require("q"),
    fs = require('fs'),
    otp = require('otplib/lib/authenticator'),
    crypto = require('crypto'),
    multer  = require('multer'),
    handlebars = require("handlebars"),
    Email = require('./email.js');

var EXPIRE_MIN=2;
var upload = multer({ dest: __dirname+'/uploads' });

module.exports = function(app) {
    
    app.post('/register', function(req, res) {
        var input = req.body;
        if(!input.email) {
            var msg = {error:"Invalid input",errorCode:"101"};
            sendResponse(res, msg);
            return;
        }
    });

    var sendResponse = function(res, msg){
        debugger;	
        if(msg.admin){
           var template = handlebars.compile(fs.readFileSync('public/uploadRes.html','UTF8'));
           res.send(template(msg));
           return;
        }
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(msg));
    };
}