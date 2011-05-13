(function() {
  var Answers, Poll, app, db, express, mongoose;
  express = require("express");
  mongoose = require("mongoose");
  Answers = new mongoose.Schema({
    answer: String
  });
  Poll = new mongoose.Schema({
    question: String,
    answers: [Answers],
    date: {
      type: Date,
      "default": Date.now
    }
  });
  mongoose.model("Poll", Poll);
  db = mongoose.connect("mongodb://localhost/simpoll");
  app = express.createServer();
  app.configure(function() {
    app.use(express.methodOverride());
    app.set('view engine', 'haml');
    return app.register('.haml', require('hamljs'));
  });
  app.get("/", function(req, res) {
    return res.render("index.html.haml");
  });
  app.get("/new", function(req, res) {
    return res.render("new.html.haml");
  });
  app.post("/create", function(req, res) {});
  app.listen(3000);
  console.log("Server started on port %s", app.address().port);
}).call(this);
