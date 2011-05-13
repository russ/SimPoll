(function() {
  var loadAnswers;
  loadAnswers = function(poll) {
    var answer, answers, _i, _len, _ref;
    answers = "";
    _ref = poll.answers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      answer = _ref[_i];
      answers += "<li><a class='answer' href='/vote/" + poll._id + "/" + answer._id + "' data-poll_id='" + poll._id + "' data-answer_id='" + answer._id + "'>" + answer.answer + "</a> : <strong>" + answer.number_of_votes + "</strong></li>";
    }
    return $("#answers").html(answers);
  };
  $(function() {
    var socket;
    socket = new io.Socket(null, {
      host: "192.168.1.167",
      port: 3000
    });
    socket.connect();
    socket.on("connect", function() {
      return console.log("Connected to Server");
    });
    socket.on("message", function(message) {
      console.log(message);
      return loadAnswers(message);
    });
    $("h1, h2, p, ul").fitText();
    return $(".answer").live("click", function(event) {
      event.preventDefault();
      return socket.send({
        poll_id: $(this).data("poll_id"),
        answer_id: $(this).data("answer_id")
      });
    });
  });
}).call(this);
