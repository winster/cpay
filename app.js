var express = require('express'),
    bodyParser = require('body-parser'),
    https = require("https"),
    http = require("http"),
    fs = require("fs"),
    ncpi = require("./ncpi.js"),
    xmlparser = require('express-xml-bodyparser'),
    WebSocketServer = require("ws").Server,
    url = require('url'),
    app = express();

app.use(bodyParser.json());
app.use(bodyParser.text({type:'application/xml'}));

require("./router.js")(app);

var secureServer = https.createServer({
    key: fs.readFileSync('./ssl/cpay-ssl.key'),
    cert: fs.readFileSync('./ssl/cpay-ssl.crt'),
    requestCert: true,
    rejectUnauthorized: false
}, app).listen('443', function() {
    console.log("Secure CPay server listening on port 443");
});

var server = http.createServer();
var wss = new WebSocketServer({server: server})
server.on('request', app);
server.listen(80);

var clients={};
wss.on("connection", function(ws) {
  var userKey = getParameterByName('user',ws.upgradeReq.url);
  clients[userKey] = ws;
  var result = {'status':'connected'}
  ws.send(JSON.stringify(result), function() {  })
  console.log("websocket connection open");
  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
    try{
      message = JSON.parse(message);
    }catch(e){
      message={"text":"send message in json format"};
    }   debugger;
    if(message.to && clients[message.to])
      clients[message.to].send(JSON.stringify(message), function(error){
          console.log('error while sending to webscoket client::'+error);
      });        
  });
  ws.on("close", function() {
    console.log("websocket connection close");    
  });
});

ncpi.beat();
setInterval(ncpi.beat, 180000);
exports = module.exports = app;

function getParameterByName(name, url) {
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    var value = decodeURIComponent(results[2].replace(/\+/g, " "));
    return value;
}
