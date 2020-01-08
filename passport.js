// Local Strategy

npm i passport
npm i passport-local
npm i cookie-session
npm start

// TODO: Sessions for users - track sessions when user is logged in, know which user is logged in and send back cookie associated with that user

// ~/server.js¥

const express = require('express')
const passport = require('passport')
const cookieSession = require('cookie-session')
const LocalStrategy = require('passport-local').Strategy;
require('./config/db')
const User = require('./models/User')
const app = express()
const port = 5000

app.use(express.json())

onDay = 1000 * 60 * 60 * 24
const cookie = cookieSession({
  maxAge: oneDay,
  secret: ['secret-key']
})

app.use(cookie);
// Initialize Passport
app.use(passport.initialize())
// User Sessions
app.use(passport.session())

// Serialize and deserialize user
passport.serializeUser((user, done) => {
  // done + parameters to pass onto the next middleware
  // done(ERROR, USER, INFO)
  // done(new Error(), user.username)
  done(null, user.username) 
  // takes the parameter that we want to serialize in cookie, must be unique
})

passport.deserializeUser((username, done) => {
  // take cookie and turn it into user from the database
  User.findOne({ username })
    .then(doc => done(null, doc))
    .catch(err => done(err, null))
})

// Implement local strategy telling Passport how to authenticate
passport.use(new LocalStrategy((username, password, done) => {
  // using the callback syntax here, where we pass (and can handle) err or returned user doc
  // could use the Promise.then.catch || async await syntax
  User.findOne({ username }, (err, user) => {
    if (err) { return done(err) }
    if (!user) {
      return done(null, null, { message: 'Incorrect username or password' });
    }
    if (user.password !== password) {
      return done(null, null, { message: 'Incorrect username or password' });
    }
    return done(null, user);
  });
}));


const isAuthenticated = (req, res, next) => {
  if (!req.user) {
    return res.status(403).send('not authenticated')
  }
  next()
}

app.get('/protected', isAuthenticated, (req, res) => {
  res.send('access protected resource')
})

app.get('/users', (req, res) => {
  User.find()
  .then(docs => res.send(docs));
})

app.post('/login', passport.authenticate('local'))

app.get('/me', isAuthenticated, (req, res) => req.user) // returns the user that made the request for their profile

// ~/ config/db.js
const mongoose = require('mongoose')
mongoose.connect(url, {useNewUrlParser: true})

mongoose.connection.on('connected', () => {
  console.log('connected to mongoDB');
})
mongoose.connection.on('error', () => {
  console.log('error connecting to database');
})

// ~/models/User

const mongoose = require('mongoose')
const userSchema = new mongoose.Schema({
  id: Number,
  username: String,
  password: String
})