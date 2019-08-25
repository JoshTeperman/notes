// Document Database vs Relational Database
// A document is a JSON object
// Tables -> Colletion
// Rows/Records -> Documents
// Columns -> Fields

// Not intended for relational databases, but can use nested objects for similar functionality

mongod // mongo daemon
mongo // termial

show dbs // show database

use pokemondb // use existing or create new database
// will not save until there is a collection

db.createCollection('pokemon')

db.pokemon.insert({
  name: "pokemon"
})

db.users.insert({
  name: "test user",
  password: "password"
})

db.pokemon.find()
// => { "_id" : ObjectId("5d02f9a502eedd679180e2b7"), "name" : "bulbasaur" }

db.pokemon.insert({
  name: "pokemon",
  _id: 1
})

db.pokemon.find()
// => { "_id" : ObjectId("5d02f9a502eedd679180e2b7"), "name" : "bulbasaur" }
// => { "_id" : 1, "name" : "bulbasaur" }

db.pokemon.insertMany([
  {_id: 2, name: "Ivysaur"},
  {_id: 3, name: "Charlamander"}
])

// Find
db.pokemon.find()
db.pokemon.findOne({name: /Ivysaur/})
db.pokemon.find({name: /saur/})

// Update
db.pokemon.update({name: "Ivysaur"}, {$set:{name: "NotIvysaur"}})
db.pokemon.update({name: "Ivysaur"}, {$set:{name: "NotIvysaur"}}, {upsert:true})

db.pokemon.update({}, {$set:{"moves":''}}, false, true)

// Delete
db.pokemon.remove({name:/saur/}) // attach optional paramater ,first ??
db.pokeon.deleteMany({name:/saur/})

// Remove Fields
unset

// Nested Queries

// create collection
db.createCollection('moves')
db.insertMany([{"name": karateChop}])

// DROP

db.moves.drop()
db.dropDatabase()

// CONNECT TO DB

const mongoURI = 'mongodb://localhost/nameOfDatabase'
mongoose.connect(mongoURI, { useNewUrlParser: true })
  .then( console.log('connected to mongodb'))


const dbName = 'countries-app'

mongoose.connect(`mongodb://localhost:27017/${dbName}`, { useNewUrlParser: true }, (err) => {
  if (err) {
    console.log('mongodb not connnected 🙄')
  } else {
    console.log('mongodb connected ✅')
  }
})


mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]

var MongoClient = require('mongodb').MongoClient
  , Server = require('mongodb').Server;

var mongoClient = new MongoClient(new Server('localhost', 27017));
mongoClient.open(function(err, mongoClient) {
  var db1 = mongoClient.db("mydb");

  mongoClient.close();
});


eg:
MONGO_PROD_URI=mongodb+srv://admin:mongodbadminuser@ca-mern-5ubc9.mongodb.net/test?retryWrites=true&w=majority

const MongoClient = require('mongodb').MongoClient;
const client = new MongoClient(process.env.MONGO_PROD_URI, { useNewUrlParser: true });
client.connect(err => {
  if (err) {
    console.log('👺  Error connecting to mongoDB');
  } else {
    console.log('✅  Connected to mongoDB');
  }
  const collection = client.db("CA-MERN").collection("users");
  client.close();
});

// Schema validation

// Mongoose has several built-in validators.

// All SchemaTypes have the built-in required validator. The required validator uses the SchemaType's checkRequired() function to determine if the value satisfies the required validator.
// Numbers have min and max validators.
// Strings have enum, match, minlength, and maxlength validators.

var breakfastSchema = new Schema({
  eggs: {
    type: Number,
    min: [6, 'Too few eggs'],
    max: 12
  },
  bacon: {
    type: Number,
    required: [true, 'Why no bacon?']
  },
  drink: {
    type: String,
    enum: ['Coffee', 'Tea'],
    required: function() {
      return this.bacon > 3;
    }
  }
});
var Breakfast = db.model('Breakfast', breakfastSchema);

var badBreakfast = new Breakfast({
  eggs: 2,
  bacon: 0,
  drink: 'Milk'
});
var error = badBreakfast.validateSync();
assert.equal(error.errors['eggs'].message,
  'Too few eggs');
assert.ok(!error.errors['bacon']);
assert.equal(error.errors['drink'].message,
  '`Milk` is not a valid enum value for path `drink`.');

badBreakfast.bacon = 5;
badBreakfast.drink = null;

error = badBreakfast.validateSync();
assert.equal(error.errors['drink'].message, 'Path `drink` is required.');

badBreakfast.bacon = null;
error = badBreakfast.validateSync();
assert.equal(error.errors['bacon'].message, 'Why no bacon?');

// =====
// Custom Validators

var userSchema = new Schema({
  phone: {
    type: String,
    validate: {
      validator: function(v) {
        return /\d{3}-\d{3}-\d{4}/.test(v);
      },
      message: props => `${props.value} is not a valid phone number!`
    },
    required: [true, 'User phone number required']
  }
});

var User = db.model('user', userSchema);
var user = new User();
var error;

user.phone = '555.0123';
error = user.validateSync();
assert.equal(error.errors['phone'].message,
  '555.0123 is not a valid phone number!');

user.phone = '';
error = user.validateSync();
assert.equal(error.errors['phone'].message,
  'User phone number required');

user.phone = '201-555-0123';
// Validation succeeds! Phone number is defined
// and fits `DDD-DDD-DDDD`
error = user.validateSync();
assert.equal(error, null);


// https://codeburst.io/things-i-wish-i-new-before-i-started-working-with-mongodb-c089d4b593db

// POPULATE

User.find().populate('clientID').exec((err, users) => {
  if (err) console.log(err);
  users.map((user) => console.log(user.clientID.companyName))
  // console.log('The company name is %s', user.clientID);
  // console.log('The company id %s', user.clientID._id);
});

=== 

var personSchema = Schema({
  _id: Number,
  name: String,
  age: Number,
  stories: [{
      type: Schema.Types.ObjectId,
      ref: 'Story'
  }]
});
var storySchema = Schema({
  _creator: {
      type: Number,
      ref: 'Person'
  },
  title: String,
  fans: [{
      type: Number,
      ref: 'Person'
  }]
});
var Story = mongoose.model('Story', storySchema);
var Person = mongoose.model('Person', personSchema);

Story.findOne({
  title: 'Once upon a timex.'
})
.populate('_creator')
.exec(function (err, story) {
  if (err) return handleError(err);
  console.log('The creator is %s', story._creator.name);
  // prints "The creator is Aaron"
});

//  STREAMING

var cursor = Person.find({ occupation: /host/ }).cursor();
cursor.on('data', function(doc) {
  // Called once for every document
});
cursor.on('close', function() {
  // Called when done
});

//  SEARCH & SELECT SPECIFIC ATTRIBUTES

User.findById(id).select("name email").exec(function (err, user) {
  var item = {
      name: user.name,
      email: user.email
  }
  addToList(item);
})

// The select property would tell mongo that it only needs to get the name and email from the document and thus makes for more efficient code.
// Note — if you want to get all the keys except some you can prefix it with “-” . Eg-
// select("-password -token")


// ARRAY MANIPULATION

Model.update() // only the first doc found 
Model.updateOne() // same but doesn't suport multi or overWrite options
Model.updateMany() // all docs that match the filter
replaceOne() // if you want to overwrite an entire document rather than using atomic operators like $set.

// ! The operation is only executed when a callback is passed. To force execution without a callback, we must first call update() and then execute it by using the exec() method.


Model.update({filter}, {doc}, {options}, callback = () => {})
=> { "acknowledged" : true, "matchedCount" : 1, "modifiedCount" : 1 }
=> { }
// returns a document that contains the information about the status of the operation
therefore...
.exec(err, result) => {
  if (result.matchedCount === 0) {
    // do something if no document matched ...
  }  
}

filter: // The selection criteria for the update. The same query selectors as in the find() method are available. Specify an empty document { } to update the first document returned in the collection.
update: // The modifications to apply. Use Update Operators such as $set, $unset, or $rename. Using the update() pattern of field: value for the update parameter throws an error.


// https://mongoosejs.com/docs/2.7.x/docs/updating-documents.html
// https://docs.mongodb.com/manual/reference/method/db.collection.updateOne/

Model.where({ _id: id }).update({ $set: { title: 'words' }})

// update multiple fields in the SAME document:
db.books.updateOne (
  { _id: 123456789, available: { $gt: 0 } },
  {
    $inc: { available: -1 },
    $push: { checkout: { by: "abc", date: new Date() } }
  }
)

User.update({
  _id: userId
}, {
  $push: {
      followers: "foo_bar"
  }
}).exec(function(err, user){
  console.log("foo_bar is added to the list of your followers");
})

User.update({
  _id: userId
}, {
  $pull: {
      followers: "foo_bar"
  }
}).exec(function(err, user){
  console.log("foo_bar is removed from the list of your followers");
})


upsert: // (boolean) whether to create the doc if it doesn't match (false)
multi: // (boolean) whether multiple documents should be updated (false)
runValidators: // if true, runs update validators on this command. Update validators validate the update operation against the model's schema.
setDefaultsOnInsert: // if this and upsert are true, mongoose will apply the defaults specified in the model's schema if a new document is created. This option only works on MongoDB >= 2.4 because it relies on MongoDB's $setOnInsert operator.
strict: // (boolean) overrides the strict option for this update
overwrite: // (boolean) disables update-only mode, allowing you to overwrite the doc (false)
context: // (string) if set to 'query' and runValidators is on, this will refer to the query in custom validator functions that update validation runs. Does nothing if runValidators is false. 
read: //
writeConcern: //



// MODEL.$WHERE()
Blog.$where('this.username.indexOf("val") !== -1').exec(function (err, docs) {});


// MODEL.COUNT()
Adventure.count({ type: 'jungle' }, function (err, count) {
  if (err) ..
  console.log('there are %d jungle adventures', count);
});

// MODEL.EXISTS()
// Returns true if at least one document exists in the database that matches the given filter, and false otherwise.
await Character.create({ name: 'Jean-Luc Picard' });
await Character.exists({ name: /picard/i }); // true

MODEL.FIND()
// named john and at least 18
MyModel.find({ name: 'john', age: { $gte: 18 }});
// executes, name LIKE john and only selecting the "name" and "friends" fields
MyModel.find({ name: /john/i }, 'name friends', function (err, docs) { })

Model.findByIdAndDelete()
Model.findByIdAndUpdate()
Model.findOneAndDelete()
Model.findOneAndUpdate()
