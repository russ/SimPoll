(function() {
  var answers_template, loadAnswers;
  answers_template = "  {{#answers}}    <li><a class='answer' href='#' data-poll_id='{{poll_id}}' data-answer_id='{{_id}}'>{{answer}}</a> : <strong>{{number_of_votes}}</strong></li>  {{/answers}}";
  loadAnswers = function(poll) {
    return $("#answers").html(Mustache.to_html(answers_template, {
      poll_id: poll._id,
      answers: poll.answers
    }));
  };
  $(function() {
    var socket;
    socket = new io.Socket(null, {
      port: 3000
    });
    socket.connect();
    socket.on("message", function(message) {
      return loadAnswers(message);
    });
    $("h1, h2, p, ul").fitText();
    if ($("#answers")) {
      $.getJSON("/" + $("#answers").data("poll_id") + ".json", function(data) {
        return loadAnswers(data);
      });
    }
    return $(".answer").live("click", function(event) {
      event.preventDefault();
      return socket.send({
        poll_id: $(this).data("poll_id"),
        answer_id: $(this).data("answer_id")
      });
    });
  });
}).call(this);
