sys = require "sys"
express = require "express"
mongoose = require "mongoose"
app = module.exports = express.createServer()

Answers = new mongoose.Schema
  answer: String,
  number_of_votes: { type: Number, default: 0 }

mongoose.model "Poll", new mongoose.Schema
  question: String,
  answers: [ Answers ],
  date: { type: Date, default: Date.now }

Poll = mongoose.model "Poll"

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

app.configure 'production', ->
  app.use(express.errorHandler())

app.get '/', (req, res) ->
  Poll.find {}, [ "question" ], { date: -1 }, (err, found) ->
    res.render 'index', { recent_polls: found }

app.get '/new', (req, res) ->
  res.render 'new'

app.post '/create', (req, res) ->
  poll = new Poll
    question: req.body.poll.question,
    answers: ({ answer: answer } for answer in req.body.poll.answers)

  poll.save ->
    res.redirect "/#{poll._id}"

app.get "/:id", (req, res) ->
  Poll.findById req.params.id, (err, poll) ->
    res.render "show", { poll: poll }

# app.get "/vote/:poll_id/:answer_id", (req, res) ->
#   Poll.findById req.params.poll_id, (err, poll) ->
#     answer = poll.answers.id(req.params.answer_id)
#     answer.number_of_votes = answer.number_of_votes += 1
#     poll.save (err, answer) ->
#       res.redirect "/#{poll._id}"

app.listen(3000)
console.log("Express server listening on port %d", app.address().port)

io = require "socket.io"
socket = io.listen(app)
socket.on "connection", (client) ->
  client.on "message", (message) ->
    # sys.puts sys.inspect(message)
    Poll.findById message.poll_id, (err, poll) ->
      answer = poll.answers.id message.answer_id
      answer.number_of_votes = answer.number_of_votes += 1
      poll.save (err, poll) ->
        sys.puts "sending"
        client.send poll
        client.broadcast poll
