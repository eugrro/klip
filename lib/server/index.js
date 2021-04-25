var express = require('express');
var http = require('http');
const multer = require('multer');
var fs = require('fs');
const keys = require("./keys.js")
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
const stripe = require('stripe')(keys.StripeSKey);
// Set the region 
AWS.config.update({
  region: 'us-east-1',
  accessKeyId: keys.AWSAccessKeyId,
  secretAccessKey: keys.AWSSecretKey,
});
//look into dotenv

s3 = new AWS.S3();
// bodyParser is a type of middleware
// It helps convert JSON strings
// the 'use' method assigns a middleware
app.use(bodyParser.json({ type: 'application/json' }));

const hostname = JSON.parse(fs.readFileSync('ip.json', 'utf8'))["nodeUrl"];
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

app.post('/postUser', async function (req, res) {
  console.log("Adding a New User!");

  await client.connect();

  const db = client.db('database');
  postParam = req.query;
  postParam["following"] = [];
  postParam["followers"] = [];
  postParam["subscribing"] = [];
  postParam["subscribers"] = [];
  console.log(postParam);

  db.collection('users').insertOne(postParam, function (err, res) {
    if (err) throw err;
  });
  res.sendStatus(200);
});

app.get('/getUser', async function (req, res) {
  console.log("Getting User Info!");
  const options = {
    projection: { _id: 0, uid: 0, host: 0 },
  };
  await client.connect();
  const db = client.db('database');
  var uidparam = req.query["uid"];
  console.log("Parameter for uid: " + uidparam);

  db.collection("users").findOne({ "uid": uidparam }, options, function (err, result) {
    if (err) throw err;
    res.send(result);
  });
});
app.get('/doesUserExist', async function (req, res) {
  console.log("Checking if user exists");
  const options = {
    projection: { _id: 0, uid: 0, host: 0 },
  };
  await client.connect();
  const db = client.db('database');
  var emailParam = req.query["email"];

  db.collection("users").findOne({ "email": emailParam }, options, function (err, result) {
    if (err) throw err;
    if (result == null) {
      console.log("User with email " + emailParam + " does not exists");
      res.send({
        "status": "UserDoesNotExist"
      });
    } else {
      console.log("User with email " + emailParam + " exists");
      res.send({
        "status": "UserExists"
      });
    }

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
  var input = req.query;
  var params = { "uid": input.uid };
  var par = String(input.param);
  var parVal = String(input.paramVal);
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
app.post("/uploadThumbnail", upload.single("file"), function (req, res) {

  console.log("Recieved thumbnail");

  var params = {
    Bucket: 'thumbnails-klip',
    timeout: 5000,
    Body: fs.createReadStream(req.file.path),
    Key: 'thumb_' + req.file.originalname + '.jpg',
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
          console.log("Trying to add Thumbnail to post to Mongo");
          const db = client.db('database');
          var params = {
            "thumb": data.Location,
          };

          db.collection('content').updateOne({ 'pid': req.body.pid }, { $set: params }, function (err, res) {
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
    timeout: 5000,
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
            "pid": req.file.originalname,
            "link": data.Location,
            "avatar": avatarLink,
            "uname": uname,
            "uid": uid,
            "comm": [],
            "numviews": "0",
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
            "pid": req.file.originalname,
            "numViews": "0",
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

  console.log("Printing parameters: \n");
  var input = req.query

  var par = [String(input.uid), String(input.uName), String(input.avatarLink), String(input.comm), String(input.time),];

  console.log("Comment: \n");
  console.log(par);

  db.collection('content').updateOne({ "pid": input.pid }, { $push: { "comm": par } }, function (err, res) {
    if (err) throw err;
  });
});
app.post('/reportBug', async function (req, res) {

  console.log("Got a bug report");
  var input = req.query;

  try {
    await client.connect();
    const db = client.db('database');
    var params = {
      "uid": input.uid,
      "bug": input.bug,
    };

    db.collection('bugs').insertOne(params, function (err, result) {
      if (err) { res.send({ "status": "BugReportedUnsucessfully" }); throw err; }
      console.log("Added to Mongo Sucessfully");
      res.send({ "status": "BugReportedSucessfully" });
    });
  } catch (e) {
    console.log(e);
  }
});
app.post('/addTextContent', async function (req, res) {

  console.log("Adding Text Content");

  const db = client.db('database');

  var input = req.query;

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
    console.log(req.query);
    var input = req.query
    var gamertag = input.gamertag;
    console.log(gamertag);
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    var ret = await getPlayerKlips(gamertag);
    console.log(ret);
    res.send(ret);

  } catch (e) {
    console.error(e);
  }
});
app.post('/userFollowsUser', async function (req, res) {

  console.log("Received follow request:");
  try {
    // Connect to the MongoDB cluster
    await client.connect();
    const db = client.db('database');
    var input = req.query;
    var uid1 = input.uid1;
    var uid2 = input.uid2;
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    db.collection('users').updateOne({ "uid": uid2 }, { $push: { "followers": uid1 } }, function (err, res) {
      if (err) { res.send({ "status": "FollowUnsucessful" }); throw err; }
      console.log("Added uid1 to followers list of uid2");
    });
    db.collection('users').updateOne({ "uid": uid1 }, { $push: { "following": uid2 } }, function (err, res) {
      if (err) {
        res.send({ "status": "FollowUnsucessful" }); throw err;
      }
      console.log("Added uid2 to following list of uid1");
    });
    res.send({ "status": "FollowSucessful" });

  } catch (e) {
    console.error(e);
  }
});
app.post('/userUnfollowsUser', async function (req, res) {

  console.log("Received Unfollow request:");
  try {
    // Connect to the MongoDB cluster
    await client.connect();
    const db = client.db('database');
    var input = req.query;
    var uid1 = input.uid1;
    var uid2 = input.uid2;
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    db.collection('users').updateOne({ "uid": uid2 }, { $pull: { "followers": uid1 } }, function (err, res) {
      if (err) { res.send({ "status": "UnfollowUnsucessful" }); throw err; }
      console.log("Removed uid1 to followers list of uid2");
    });
    db.collection('users').updateOne({ "uid": uid1 }, { $pull: { "following": uid2 } }, function (err, res) {
      if (err) { res.send({ "status": "UnfollowUnsucessful" }); throw err; }
      console.log("Removed uid2 to following list of uid1");
    });
    res.send({ "status": "UnfollowSucessful" });

  } catch (e) {
    console.error(e);
  }
});
app.post('/getUserContent', async function (req, res) {

  console.log("Received User Content request:");
  try {
    // Connect to the MongoDB cluster
    await client.connect();
    const db = client.db('database');
    var input = req.query;
    var uid = input.uid;
    const options = {
      projection: { _id: 0, host: 0 },
    };
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    db.collection('content').find({ "uid": uid }, options).toArray(function (err, result) {
      if (err) { res.send({ "status": "Unsuccessful" }); throw err; }
      console.log("Found all content posted by: " + uid.toString());
      console.log(result);
      res.send(result);
    });


  } catch (e) {
    console.error(e);
  }
});
app.get('/doesObjectExistInS3', async function (req, res) {

  console.log("Testing if Object Exists in S3");
  try {
    // Connect to the MongoDB cluster
    var input = req.query;
    var params = {
      Bucket: input.bucketName,
      Key: input.objectName,
    }
    console.log("Looking for object with params:");
    console.log(params);
    //call function and return
    res.setHeader('Content-Type', 'application/json');
    s3.headObject(params, function (err, metadata) {
      if (err || metadata == null) {
        console.log("Object Not Found!")
        res.send({
          "status": "ObjectNotFound"
        });
      } else {
        console.log("Object Found!");
        res.send({
          "status": "ObjectFound"
        });
      }
    });

  } catch (e) {
    console.error(e);
  }
});
app.post('/getStripeIntent', async function (req, res) {
  console.log("Trying to get user intent for user");

  /*stripe.paymentMethods.create(
    {
      payment_method: req.query.paym,
    }, {
    stripeAccount: stripeVendorAccount
  },
    function (err, clonedPaymentMethod) {
      if (err !== null) {
        console.log('Error clone: ', err);
        res.send('error');
      } else {
        console.log('clonedPaymentMethod: ', clonedPaymentMethod);
      }
    });*/
  console.log("Amount: " + req.query.amount);
  console.log("Currency: " + req.query.currency);
  console.log("Payment: " + req.query.paym);
  stripe.paymentIntents.create(
    {
      amount: req.query.amount,
      currency: req.query.currency,
      payment_method: req.query.paym,
      confirmation_method: 'automatic',
      confirm: true,
      //application_fee_amount: "2",
      description: "Trying to create a sample payment",
    },
    function (err, paymentIntent) {
      // asynchronously called
      if (err) {
        console.log("Ran into error on creating payment intent\n" + err);
      } else {
        console.log(paymentIntent);
        res.json({ paymentIntent: paymentIntent });
      }
    });
});

app.get('/doesUsernameExist', async function (req, res) {
  console.log("Checking if username exists");
  const options = {
    projection: { _id: 0, uid: 0, host: 0 },
  };
  await client.connect();
  const db = client.db('database');
  var unameParam = req.query["uname"];

  db.collection("users").findOne({ "uname": unameParam }, options, function (err, result) {
    if (err) throw err;
    if (result == null) {
      console.log("User with username " + unameParam + " does not exists");
      res.send({
        "status": "UsernameDoesNotExist"
      });
    } else {
      console.log("User with username " + unameParam + " exists");
      res.send({
        "status": "UsernameExists"
      });
    }

  });
});


app.post('/updateusername', async function (req, res) {
  console.log("Updating Username");

  await client.connect();

  const db = client.db('database');

  console.log("Printing Headers: \n");
  console.log(req.headers);
  var input = req.query;

  var usernameparam = { "uname": input.uname };
  console.log(usernameparam);
  db.collection('users').updateOne({ "uid": input.uid }, { $set: usernameparam }, function (err, res) {
    if (err) throw err;
  });
  console.log("Successfully updated the username");
  res.sendStatus(200);
});


