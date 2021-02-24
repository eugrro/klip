var express = require('express');
var http = require('http');
const multer = require('multer');
var fs = require('fs');
const upload = multer({ dest: __dirname + '/uploads' });
const MongoClient = require('mongodb').MongoClient;
const uri = "mongodb+srv://adminUser:testPassword123@devcluster.ikqun.mongodb.net/database?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
var bodyParser = require('body-parser');
const { privateEncrypt } = require('crypto');
var app = express();
// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
const { umask } = require('process');
var XboxLiveAuth = require('@xboxreplay/xboxlive-auth'); // https://github.com/XboxReplay/xboxlive-auth
var XboxLiveApi = require('@xboxreplay/xboxlive-api'); // https://github.com/XboxReplay/xboxlive-api
const { getPlayerKlips } = require('./xbox-clips');
// Set the region 
AWS.config.update({
  region: 'us-east-1',
  accessKeyId: 'AKIAJPZKSIHC4PSAEHWQ',
  secretAccessKey: '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',
});
//look into dotenv

s3 = new AWS.S3();
// bodyParser is a type of middleware
// It helps convert JSON strings
// the 'use' method assigns a middleware
app.use(bodyParser.json({ type: 'application/json' }));

//const hostname = '127.0.0.1';
const hostname = '192.168.1.124';
const port = 3000;

// http status codes
const statusOK = 200;
const statusNotFound = 404;

app.listen(port, hostname, function () {
  console.log(`Listening at http://${hostname}:${port}/...`);
});

app.get('/', async function (req, res) {
  res.send('<h3>Server is up and Running</h3>');
});
//============================================================================================================//
//                                                                                                            //
//                                             Testing Functions                                              //    
//                                                                                                            //    
//============================================================================================================//
async function testMongoConnection() {
  await client.connect();
  const db = client.db('database');
  const options = {
    // Include only the `title` and `imdb` fields in the returned document
    projection: { _id: 0, uid: 0, host: 0 },
  };
  var uidparam = "xT775nBGbkQb0kcIR1ARe33rjAo1"
  console.log("Parameter for uid: " + uidparam);

  db.collection("users").findOne({ "uid": uidparam }, options, function (err, result) {
    if (err) throw err;
    console.log(result);
  });
}

//var test = testMongoConnection().then(console.log("done"));
//============================================================================================================//
//                                                                                                            //
//                                             Testing Functions                                              //    
//                                                                                                            //    
//============================================================================================================//

app.get('/listContentS3', function (req, res) {
  var params = {
    Bucket: 'content-klip',
  };

  // Call S3 to obtain a list of the objects in the bucket
  s3.listObjects(params, function (err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data);
    }
    res.send('<h3>data returned in terminal</h3>')
  });
});

app.get('/getSample', function (req, res) {
  var params = {
    Bucket: 'content-klip',
    Key: 'testVid.mp4',
  };

  // Call S3 to obtain a list of the objects in the bucket
  s3.getObject(params, function (err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data.Body);
    }
    res.send('<h3>data returned in terminal</h3>')
  });
});

app.post('/users', async function (req, res) {
  console.log("Adding a New User!");

  await client.connect();

  const db = client.db('database');
  console.log(req.rawheaders);

  db.collection('users').insertOne(req.headers, function (err, res) {
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.get('/users', async function (req, res) {
  console.log("Getting User Info!");
  const options = {
    // Include only the `title` and `imdb` fields in the returned document
    projection: { _id: 0, uid: 0, host: 0 },
  };
  await client.connect();
  const db = client.db('database');
  var uidparam = req.header("uid");
  console.log("Parameter for uid: " + uidparam);

  db.collection("users").findOne({ "uid": uidparam }, options, function (err, result) {
    if (err) throw err;
    res.send(result);
  });
});
//Tested working 11/24
app.get('/listUsers', async function (req, res) {
  console.log("Listing All Users!");
  await client.connect();
  const db = client.db('database');

  var ret = db.collection("users").find({}).toArray(function (err, result) {
    if (err) throw err;
    console.log(result);
    res.setHeader('Content-Type', 'application/json')
    res.json(result);
    client.close();
  });
});

//Tested working 11/24
app.post('/updateOne', async function (req, res) {
  console.log("Updating a Single Field");

  await client.connect();

  const db = client.db('database');

  console.log("Printing Headers: \n");
  console.log(req.headers);
  var input = req.headers
  var params = { "uid": input.uid };
  var par = String(input.param);
  var parVal = String(input.paramval);
  var changeParams = {};
  changeParams[par] = parVal;
  console.log("Changing Parameter: \n");
  console.log(changeParams);

  db.collection('users').updateOne(params, { $set: changeParams }, function (err, res) {
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.get('/listDatabases', async function (req, res) {

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

app.post("/uploadContent", upload.single("file"), function (req, res) {

  console.log("Recieved upload request");
  console.log("Size of object: ");
  console.log(req.file.size);
  console.log("Name of object: ");
  console.log(req.file.filename);
  var objName = req.file.filename;

  console.log("===========================");
  console.log(req.file.originalname + '.jpg');
  console.log(req.file.mimetype);
  var uid = req.body.uid;
  console.log(req.body.uid);
  var avatarLink = req.body.avatar;
  console.log(req.body.avatarLink);
  var uname = req.body.uname;
  var uid = req.body.uid;
  console.log(req.body.uid);

  var params = {
    Bucket: 'content-klip',
    timeout: 3000,
    Body: fs.createReadStream(req.file.path),
    Key: req.file.originalname + '.jpg',
  };
  try {
    s3.upload(params, async function (err, data) {
      if (err) {
        console.log("Received error: ");
        console.log(err)
        res.status(500).json({ error: true, Message: err });
      } else {
        res.send({ data });
        console.log("Sent to S3 sucessfully");

        //remove the temp stored file
        var deletePath = req.file.path;

        fs.unlink(deletePath, function (err) {
          if (err) return console.log(err);
          console.log('File deleted from local storage successfully');
        });

        //Add link to mongo List
        try {
          await client.connect();
          console.log("Trying to add Content Link to Mongo");
          const db = client.db('database');
          var params = {
            "type": "img",
            "pid": objName,
            "link": data.Location,
            "avatar": avatarLink,
            "uname": uname,
            "uid": uid,
            "comm": [],
          };

          db.collection('content').insertOne(params, function (err, res) {
            if (err) throw err;
            console.log("Added to Mongo Sucessfully");
          });
        } catch (e) {
          console.log(e);
        }
      }
    });
  } catch (e) {
    console.log("Received error: ");
    console.log(e);
    res.status(300);
  }


  res.status(200);
});

app.post("/uploadKlip", upload.single("file"), function (req, res) {

  console.log("Recieved upload request");
  console.log("Size of object: ");
  console.log(req.file.size);
  console.log("Name of object: ");
  console.log(req.file.filename);
  var objName = req.file.filename;

  console.log("===========================");
  console.log(req.file.originalname + '.mp4');
  console.log(req.file.mimetype);
  var uid = req.body.uid;
  console.log(req.body.uid);
  var avatarLink = req.body.avatar;
  console.log(req.body.avatarLink);
  var uname = req.body.uname;
  var uid = req.body.uid;
  console.log(req.body.uid);

  var params = {
    Bucket: 'content-klip',
    timeout: 3000,
    Body: fs.createReadStream(req.file.path),
    Key: req.file.originalname + '.mp4',
  };
  try {
    s3.upload(params, async function (err, data) {
      if (err) {
        console.log("Received error: ");
        console.log(err)
        res.status(500).json({ error: true, Message: err });
      } else {
        res.send({ data });
        console.log("Sent to S3 sucessfully");

        //remove the temp stored file
        var deletePath = req.file.path;

        fs.unlink(deletePath, function (err) {
          if (err) return console.log(err);
          console.log('File deleted from local storage successfully');
        });

        //Add link to mongo List
        try {
          await client.connect();
          console.log("Trying to add Content Link to Mongo");
          const db = client.db('database');
          var params = {
            "type": "vid",
            "pid": objName,
            "link": data.Location,
            "avatar": avatarLink,
            "uname": uname,
            "uid": uid,
            "comm": [],
          };

          db.collection('content').insertOne(params, function (err, res) {
            if (err) throw err;
            console.log("Added to Mongo Sucessfully");
          });
        } catch (e) {
          console.log(e);
        }
      }
    });
  } catch (e) {
    console.log("Received error: ");
    console.log(e);
    res.status(300);
  }


  res.status(200);
});

app.post("/uploadAvatar", upload.single("file"), function (req, res) {

  console.log("Recieved upload request");
  console.log("Size of object: ");
  console.log(req.file.size);
  console.log("Name of object: ");
  console.log(req.file.filename);

  console.log("===========================");
  console.log(req.file.originalname + '.jpg');
  console.log(req.file.mimetype);
  var uid = req.body.uid;
  console.log(req.body.uid);

  var params = {
    Bucket: 'avatars-klip',
    timeout: 3000,
    Body: fs.createReadStream(req.file.path),
    Key: req.file.originalname + '.jpg',
  };
  try {
    s3.upload(params, async function (err, data) {
      if (err) {
        console.log("Received error: ");
        console.log(err)
        res.status(500).json({ error: true, Message: err });
      } else {
        console.log("Sent to S3 sucessfully");

        //remove the temp stored file
        var deletePath = req.file.path;

        fs.unlink(deletePath, function (err) {
          if (err) return console.log(err);
          console.log('File deleted from local storage successfully');
        });

        //Add link to mongo List
        try {
          await client.connect();
          console.log("Trying to add Avatar Link to Mongo");
          const db = client.db('database');
          var changeParams = {
            "avatar": data.Location,
          };

          db.collection('users').updateOne({ "uid": uid }, { $set: changeParams }, function (err, res) {
            if (err) throw err;
          });
          res.send({ data });
          console.log("Added to Mongo Sucessfully");

        } catch (e) {
          console.log(e);
        }
      }
    });
  } catch (e) {
    console.log("Received error: ");
    console.log(e);
    res.status(300);
  }


  res.status(200);
});

app.get('/listContentMongo', async function (req, res) {

  console.log("Listing All Content");
  try {
    // Connect to the MongoDB cluster
    await client.connect()
      .then(console.log("Connected to client"));

    const options = {
      projection: { _id: 0, host: 0 },
    };

    // Make the appropriate DB calls
    const db = client.db('database');
    var ret = db.collection("content").find({}, options).toArray(function (err, result) {
      if (err) throw err;
      console.log(result);
      res.setHeader('Content-Type', 'application/json')
      res.json(result);
    });

  } catch (e) {
    console.error(e);
  }
});

app.post('/addComment', async function (req, res) {

  console.log("Adding Comment");
  await client.connect();

  const db = client.db('database');

  console.log("Printing Headers: \n");
  console.log(req.headers);
  var input = req.headers
  var params = { "pid": input.pid };
  console.log(input);

  var par = [String(input.uid), String(input.uname), String(input.avatarlink), String(input.comm), String(input.time),];

  console.log("Comment: \n");
  console.log(par);

  db.collection('content').updateOne(params, { $push: { "comm": par } }, function (err, res) {
    if (err) throw err;
  });
});

app.post('/addTextContent', async function (req, res) {

  console.log("Adding Text Content");
  await client.connect();

  const db = client.db('database');

  console.log("Printing Headers: \n");
  console.log(req.headers);

  var input = req.headers

  console.log("Title: ");
  console.log(input.title);
  console.log("Body: ");
  console.log(input.body);

  try {
    await client.connect();
    console.log("Trying to add Text Content to Mongo");
    const db = client.db('database');
    var params = {
      "type": "txt",
      "pid": input.pid,
      "uid": input.uid,
      "avatar": input.avatar,
      "uname": input.uname,
      "title": input.title,
      "body": input.body,
      "comm": [],
    };

    db.collection('content').insertOne(params, function (err, res) {
      if (err) throw err;
      console.log("Added to Mongo Sucessfully");
      res.send(result);
    });
  } catch (e) {
    console.log(e);
  }
});
app.get('/getXboxClips', async function (req, res) {

  console.log("Getting Xbox Clips for User:");
  try {
    // Connect to the MongoDB cluster
    console.log(req.headers);
    var input = req.headers
    var gamertag = input.gamertag;
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    res.send(await getPlayerKlips(gamertag));

  } catch (e) {
    console.error(e);
  }
});
