answers_template = "
  {{#answers}}
    <li><a class='answer' href='#' data-poll_id='{{poll_id}}' data-answer_id='{{_id}}'>{{answer}}</a> : <strong>{{number_of_votes}}</strong></li>
  {{/answers}}"

loadAnswers = (poll) ->
  $("#answers").html(Mustache.to_html(answers_template, { poll_id: poll._id, answers: poll.answers }))

$ ->
  socket = new io.Socket null, { port: 3000 }
  socket.connect()
  socket.on "message", (message) ->
    loadAnswers message

  $("h1, h2, p, ul").fitText()

  if $("#answers")
    $.getJSON "/" + $("#answers").data("poll_id") + ".json", (data) -> loadAnswers data

  $(".answer").live "click", (event) ->
    event.preventDefault()
    socket.send {
      poll_id: $(@).data "poll_id"
      answer_id: $(@).data "answer_id" }
