var express    = require('express'),
    drsParser  = require('./lib/drs-parser').drsParser

var app = module.exports = express.createServer();

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view options', {layout: false});
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

app.get('/drs', function(req, res){
  res.render('drs', { layout: false, title: 'DRS' })
});

app.get('/tree', function(req, res){
  res.render('tree', { title: 'Tree' })
});

app.post('/drs/visualize', function(req, res){
  result = drsParser.parse(req.body.data, 'drs')
  console.log(JSON.stringify(result, null, '  '));
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode",
            app.address().port,
            app.settings.env);
