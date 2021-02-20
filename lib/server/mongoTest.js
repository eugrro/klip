
const MongoClient = require('mongodb').MongoClient;
const uri = "mongodb+srv://adminUser:testPassword123@devcluster.ikqun.mongodb.net/database?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
client.connect(err => {
    const collection = client.db("database").collection("users").findOne();
    console.log(collection);
    client.close();
});
