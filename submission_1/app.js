var express = require("express");
var path = require("path");
var favicon = require("serve-favicon");
var logger = require("morgan");
var bodyParser = require("body-parser");
var lessMiddleware = require("less-middleware");
var MongoClient = require("mongodb").MongoClient,
  assert = require("assert");

var host = process.env.DB_HOST ? process.env.DB_HOST : "localhost";
var url = "mongodb://" + host + ":27017/accumulator";
var db;
var index = require("./routes/index");

process.title = "ca-app";

var environment = process.env.NODE_ENV ? process.env.NODE_ENV : "development";
environment = environment.trim();
console.log("NODE_ENV: " + environment);

var app = express();

MongoClient.connect(url, function (err, mongoDb) {
  assert.equal(null, err);
  console.log("Connected to database");

  db = mongoDb;
});

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "jade");
if (environment === "development") {
  app.locals.pretty = true;
}

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(lessMiddleware(path.join(__dirname, "public")));
app.use(express.static(path.join(__dirname, "public")));

app.use("/", index);

var insertDocument = function (db, document, callback) {
  var collection = db.collection("documents");
  collection.insertOne(document, function (err, result) {
    callback(err, JSON.stringify(result.ops[0]));
  });
};

var findAllDocuments = function (db, callback) {
  var collection = db.collection("documents");
  collection.find({}).toArray(function (err, result) {
    if (result) {
      result = result.reverse();
    }
    callback(err, result);
  });
};

// Insert message
app.post("/api", function (req, res) {
  var data = req.body;
  insertDocument(db, data, function (err, result) {
    res.status(201).send(result);
  });
});

// Get messages
app.get("/api", function (req, res) {
  findAllDocuments(db, function (err, result) {
    res.send(result);
  });
});

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  var err = new Error("Not Found");
  err.status = 404;
  next(err);
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = environment === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
