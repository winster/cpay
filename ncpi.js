var otp = require("otplib/lib/authenticator"),
    Q = require("q"),
    https = require('https'),
    fs = require('fs')
    connection = require('./connection.js'),
    ca = fs.readFileSync('./ssl/upi-ssl.cer'),
    https = require("https"),
    upi = require("./upi.json");

var NCPI = function(){};
NCPI.prototype.beat = function(){
    var d = Q.defer();
    var cmd = require('child_process').spawn('java', ['xml/SignatureGenUtil']);
    var body = fs.readFileSync("./xml/Hbt_signed.xml", "utf8");
    var options = {
        host: upi.host,
        port: upi.port,
        path: '/upi/ReqHbt/1.0/urn:txnid:808080787878',
        rejectUnauthorized: false,
        requestCert: true,
        agent: false,
        method: "POST",
        headers: {
            'Content-Type': 'application/xml',
            'Accept': 'application/xml'
        }
    };
    options.agent = new https.Agent(options);
    var req = https.request(options, function(res) {
       console.log( res.statusCode );
       var buffer = "";
       res.on( "data", function( data ) { buffer = buffer + data; } );
       res.on( "end", function( data ) { console.log( buffer ); d.resolve(buffer);} );
    });
    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
      d.reject({error:"User already exists", errorCode:"121"});
    });
    req.write( body );
    req.end();
    return d.promise; 

};
NCPI.prototype.pay = function(input){debugger;
    var d = Q.defer();
    var cmd = require('child_process').spawn('java', ['xml/SignatureGenUtil']);
    var body = fs.readFileSync("./xml/ReqPay_signed.xml", "utf8");
    var options = {
        host: upi.host, 
        port: upi.port, 
        path: '/upi/ReqPay', 
        rejectUnauthorized: false,
        requestCert: true,
        agent: false,
        method: "GET",
        headers: {
            'Content-Type': 'application/xml',
            'Accept': '*/*'
        }
    };
    options.agent = new https.Agent(options);

    var req = https.request(options, function(res) {debugger;
       console.log( res.statusCode );
       var buffer = "";
       res.on( "data", function( data ) { debugger;buffer = buffer + data; } );
       res.on( "end", function( data ) { debugger;console.log( buffer ); d.resolve(buffer);} );
    });
    req.on('error', function(e) {debugger;
        console.log('problem with request: ' + e.message);
        d.reject({error:"User already exists", errorCode:"121"});
    });
    console.log('headers>>'+req);
    req.write( body );
    req.end();            
    return d.promise;
};
module.exports = new NCPI();


