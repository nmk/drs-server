express   = require 'express'
drsParser = require('./lib/drs-parser').drsParser

app = module.exports = express.createServer()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view options', layout: false
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler(dumpExceptions: true, showStack: true)

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/drs', (req, res) ->
  res.render 'drs', layout: false

app.get '/tree', (req, res) ->
  res.render 'tree', layout: false

app.post '/drs/visualize', (req, res) ->
  result = drsParser.parse req.body.data, 'drs'
  res.end JSON.stringify(result, null, '  ')

app.listen 3000
console.log("Express server listening on port %d in %s mode",
            app.address().port,
            app.settings.env)
