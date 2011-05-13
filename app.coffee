express = require "express"
mongoose = require "mongoose"
app = module.exports = express.createServer()

Answers = new mongoose.Schema
  answer: String

Poll = new mongoose.Schema
  question: String,
  answers: [ Answers ],
  date: { type: Date, default: Date.now }

mongoose.model "Poll", Poll

db = mongoose.connect("mongodb://localhost/simpoll")
 
app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))

app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

# 
# app.configure('production', function(){
#   app.use(express.errorHandler()); 
# });
# 
# // Routes

app.get '/', (req, res) ->
  res.render 'index',
    { title: 'Express' }

if !module.parent
  app.listen(3000)
  console.log("Express server listening on port %d", app.address().port)
