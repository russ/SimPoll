express = require "express"
mongoose = require "mongoose"

Answers = new mongoose.Schema
  answer: String

Poll = new mongoose.Schema
  question: String,
  answers: [ Answers ],
  date: { type: Date, default: Date.now }

mongoose.model "Poll", Poll

db = mongoose.connect("mongodb://localhost/simpoll")

app = express.createServer()

app.configure ->
  app.use(express.methodOverride())
  # app.use(express.bodyDecoder())
  # app.use(express.staticProvider(__dirname + '/public'))
  # app.use(express.compiler({src: __dirname + '/public', enable: ['sass']}))
  # app.use(express.logger())

  app.set('view engine', 'haml')
  app.register('.haml', require('hamljs'))

app.get "/", (req, res) ->
  res.render "index.html.haml"

app.get "/new", (req, res) ->
  res.render "new.html.haml"

app.post "/create", (req, res) ->
  # res.render "new_question.haml"

app.listen 3000

console.log "Server started on port %s", app.address().port
