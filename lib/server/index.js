var express = require('express');
var http = require('http');
var mongo = require('mongodb');
var MongoClient = mongo.MongoClient;
const uri = "mongodb+srv://adminUser:testPassword123!@devcluster.ikqun.mongodb.net/database?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true,  useUnifiedTopology: true});
var bodyParser = require('body-parser');
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

async function userData(client){
    
    await client.connect();

    const db = client.db('database');

    const items = await db.collection('users').find({}).toArray();
    console.log(items);
    // close connection
    //client.close();
    return items;
  
};
app.listen(port, hostname, function () {
    console.log(`Listening at http://${hostname}:${port}/...`);
});
app.get('/', async function (req, res) {
    var ret = await userData(client);
    res.send(ret);
  });