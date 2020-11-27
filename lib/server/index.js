var express = require('express');
var http = require('http');
const multer = require('multer');
var fs = require('fs');
const upload = multer({dest: __dirname + '/uploads'});
const MongoClient = require('mongodb').MongoClient;
const uri = "mongodb+srv://adminUser:testPassword123@devcluster.ikqun.mongodb.net/database?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true,  useUnifiedTopology: true});
var bodyParser = require('body-parser');
const { privateEncrypt } = require('crypto');
var app = express();
// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
// Set the region 
AWS.config.update({
  region: 'us-east-1', 
  accessKeyId: 'AKIAJWA4ZK5QA2BDTAZQ', 
  secretAccessKey: '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',
});
//look into dotenv

s3 = new AWS.S3();
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
    //res.sendStatus(200);
    res.send('<h3>Server is up and Running</h3>');
  });
app.get('/listContent', function (req, res){
  var params = {
    Bucket : 'klip-content',
  };

  // Call S3 to obtain a list of the objects in the bucket
  s3.listObjects(params, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data);
    }
    res.send('<h3>data returned in terminal</h3>')
  });
});   

app.get('/getSample', function (req, res){
  var params = {
    Bucket : 'klip-content',
    Key: 'testVid.mp4',
  };

  // Call S3 to obtain a list of the objects in the bucket
  s3.getObject(params, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data.Body);
    }
    res.send('<h3>data returned in terminal</h3>')
  });
});  

app.get('/listContent', function (req, res){
  
  // Call S3 to obtain a list of the objects in the bucket
  s3.listObjects(bucketParams, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data);
    }
    res.send('<h3>data returned in terminal</h3>')
  });
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
    console.log("Parameter for uid: " + uidparam);
    
    db.collection("users").findOne({"uid": uidparam}, options, function(err, result) {
        if (err) throw err;
        res.send(result);
      });
});
//Tested working 11/24
app.get('/listUsers', async function(req, res){
    console.log("Listing All Users!");
    await client.connect();
    const db = client.db('database');
    
    var ret = db.collection("users").find({}).toArray(function(err, result) {
        if (err) throw err;
        console.log(result);
        res.setHeader('Content-Type', 'application/json')
        res.json(result);
        client.close();
      });
});

//Tested working 11/24
app.post('/updateOne', async function(req, res){
    console.log("Updating a Single Field");

    await client.connect();

    const db = client.db('database');

    console.log("Printing Headers: \n");
    console.log(req.headers);
    var input = req.headers
    var params = {"uid": input.uid};
    var par = String(input.param);
    var parVal = String(input.paramval);
    var changeParams = {};
    changeParams[par] = parVal;
    console.log("Changing Parameter: \n");
    console.log(changeParams);
    
    db.collection('users').updateOne(params, {$set: changeParams}, function(err, res){
        if(err) throw err;
    });
    res.sendStatus(200);
});

app.get('/listDatabases', async function(req, res){

    console.log("Listing Databases");
    try {
        // Connect to the MongoDB cluster
        await client.connect();
 
        // Make the appropriate DB calls
        const db = client.db('database');
        const item = await db.listCollections({}, function (findErr, result) {
            if (findErr) throw findErr;
            console.log(result.name);
            client.close();
          });
 
    } catch (e) {
        console.error(e);
    } 
});

app.post("/upload", upload.single("file"), function(req, res) {
  
  console.log("Recieved upload request");
  console.log("Size of object: " );
  console.log(req.file.size);
  console.log("Name of object: " );
  console.log(req.file.filename);

  console.log("===========================");
  console.log(req.file.originalname + '.jpg');
  console.log(req.file.mimetype);

  var params = {
    Bucket : 'klip-content',
    timeout: 3000,
    Body: fs.createReadStream(req.file.path),
    Key: req.file.originalname + '.jpg',
  };
  try{
  s3.upload(params, async function(err, data) {
    if (err) {
      console.log("Received error: ");
      console.log(err)
      res.status(500).json({ error: true, Message: err });
    } else {
      res.send({ data });
      console.log("Sent to S3 sucessfully");

      //remove the temp stored file
      var deletePath = req.file.path;
  
      fs.unlink(deletePath,function(err){
        if(err) return console.log(err);
        console.log('File deleted from local storage successfully');
      }); 

      //Add link to mongo List
      try{
        await client.connect();
        console.log("Trying to add Content Link to Mongo");
        const db = client.db('database');
        var params = {
          "link": data.Location, 
        };
    
        db.collection('content').insertOne(params, function(err, res){
          if(err) throw err;
          console.log("Added to Mongo Sucessfully");
        });
      }catch(e){
        print(e);
      }
    }
  });
  }catch(e){
    console.log("Received error: ");
    console.log(e);
    res.status(300);
  } 


  res.status(200);
});
