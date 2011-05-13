loadAnswers = (poll) ->
  answers = ""
  for answer in poll.answers
    answers += "<li><a class='answer' href='/vote/" + poll._id + "/" + answer._id + "' data-poll_id='" + poll._id + "' data-answer_id='" + answer._id + "'>" + answer.answer + "</a> : <strong>" + answer.number_of_votes + "</strong></li>"
  $("#answers").html(answers)

$ ->
  socket = new io.Socket null, { host: "192.168.1.167", port: 3000 }
  socket.connect()
  socket.on "connect", ->
    console.log "Connected to Server"

  socket.on "message", (message) ->
    console.log message
    loadAnswers message

  $("h1, h2, p, ul").fitText()

  $(".answer").live "click", (event) ->
    event.preventDefault()
    # console.log event
    # console.log $(@).data("poll_id")
    # console.log $(@).data("answer_id")
    socket.send {
      poll_id: $(@).data "poll_id"
      answer_id: $(@).data "answer_id" }
