var express = require('express'),
    bodyParser = require('body-parser');

var app = express();
app.use(express.static(__dirname+'/public'));
app.use(bodyParser.json());
app.set('port', (5000));

require("./router.js")(app);
app.listen(app.get('port'), function() {
  console.log('Cafe app is running on port', app.get('port'));
});
exports = module.exports = app;

