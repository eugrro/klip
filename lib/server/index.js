var express = require('express');
var http = require('http');
var mongo = require('mongodb');
var MongoClient = mongo.MongoClient;
const uri = "mongodb+srv://adminUser:testPassword123!@devcluster.ikqun.mongodb.net/database?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true,  useUnifiedTopology: true});
var bodyParser = require('body-parser');
const { privateEncrypt } = require('crypto');
var app = express();

    // bodyParser is a type of middleware
    // It helps convert JSON strings
    // the 'use' method assigns a middleware
app.use(bodyParser.json({ type: 'application/json' }));

const hostname = '127.0.0.1';
const port = 3000;

// http status codes
const statusOK = 200;
const statusNotFound = 404;

app.listen(port, hostname, function () {
    console.log(`Listening at http://${hostname}:${port}/...`);
});

app.get('/', async function (req, res) {
    res.sendStatus(404);
  });

app.post('/users', async function(req, res){
    console.log("Adding a New User!");

    await client.connect();

    const db = client.db('database');
    console.log(req.rawheaders);
    
    db.collection('users').insertOne(req.headers, function(err, res){
        if(err) throw err;
    });
    res.sendStatus(200);
});

app.get('/users', async function(req, res){
    console.log("Getting User Info!");
    const options = {
        // Include only the `title` and `imdb` fields in the returned document
        projection: { _id: 0, uid: 0,  host: 0},
      };
    await client.connect();
    const db = client.db('database');
    var uidparam = req.header("uid");
    
    db.collection("users").findOne({"uid": uidparam}, options, function(err, result) {
        if (err) throw err;
        res.send(result);
      });
});

app.post('/updateOne', async function(req, res){
    console.log("Updating a Single Field");

    await client.connect();

    const db = client.db('database');
    console.log("Printing Raw Headers: " + req.rawheaders);
    console.log("Printing Headers: " + req.headers);
    
    //db.collection('users').updateOne(, {$set: {profilePic: "Jessica"}}, function(err, res){
    //    if(err) throw err;
    //});
    res.sendStatus(200);
});
