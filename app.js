var express = require('express'),
    bodyParser = require('body-parser'),
    https = require("https"),
    fs = require("fs");

var app = express();
app.use(express.static(__dirname+'/public'));
app.use(bodyParser.json());
app.set('port', (process.env.PORT || 5000));

require("./router.js")(app);
/*app.listen(app.get('port'), function() {
  console.log('Cafe app is running on port', app.get('port'));
});*/
var secureServer = https.createServer({
    key: fs.readFileSync('./ssl/server.key'),
    cert: fs.readFileSync('./ssl/server.crt'),
    ca: fs.readFileSync('./ssl/cpay-ssl.crt'),
    requestCert: true,
    rejectUnauthorized: false
}, app).listen('443', function() {
    console.log("Secure Express server listening on port 8443");
});
exports = module.exports = app;

