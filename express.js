const express = require('express');
const app = express();
const port = process.env.PORT || 5000;

const bodyParser = require('body-parser')
const cors = require('cors')
app.use(bodyParser.urlencoded({extended: true}));
// app.use(bodyParser.urlencoded({extended: false}))
// app.use(bodyParser.json())
app.use(cors())

app.get('/api/express-data', (req, res) => {
  res.send({express: 'YOUR EXPRESS BACKEND IS CONNECTED TO REACT'})
})  

app.listen(port, (req, res) => {
  console.log(`Listening on Port ${port}`)
})// ROUTING //

const router = express.Router();
routes/index.js
app.use(require('./routes'))

// ~/routes/index.js
const express = require('express')
const router = express.Router();

module.exports = router;


template:
app.METHOD(PATH, HANDLER)
// app is an instance of express.
// METHOD is an HTTP request method, in lowercase.
// PATH is a path on the server.
// HANDLER is the function executed when the route is matched.
// Assumption: instance of express named app is created and the server is running

// Routes //
// http://expressjs.com/en/guide/routing.html

// Simple GET route:

app.get('/', function (req, res) {
  res.send('Hello World!')
})

// Simple POST route:

app.post('/', function (req, res) {
  res.send('Got a POST request')
})

// Simple PUT route:

app.put('/user', function (req, res) {
  res.send('Got a PUT request at /user')
})

// Simple DELETE route:

app.delete('/user', function (req, res) {
  res.send('Got a DELETE request at /user')
})


// * Serve Static Files (css, html, JS files)
// http://expressjs.com/en/4x/api.html#express.static
// ... uses express.static built-in middleware fuction:

express.static(root, [options])
// Root: The root argument specifies the root directory from which to serve static assets.
// Options: 
// -- redirect:	Redirect to trailing “/” when the pathname is a directory.	Default: true
// -- setHeaders:	Function for setting HTTP headers to serve with the file. 

// For example, use the following code to serve images, CSS files, and JavaScript files in a directory named public:

app.use(express.static('public'))
// => can now visit /filename to load the files in public 

// create a virtual path:
app.use('/static', express.static('public'))
// => now you can load files from /static/filename

// However, the path that you provide to the express.static function is relative to the directory from where you launch your node process. If you run the express app from another directory, it’s safer to use the absolute path of the directory that you want to serve:

app.use('/static', express.static(path.join(__dirname, 'public')))

// 404 Responses?
// How do I handle 404 responses?
// In Express, 404 responses are not the result of an error, so the error-handler middleware will not capture them. This behavior is because a 404 response simply indicates the absence of additional work to do; in other words, Express has executed all middleware functions and routes, and found that none of them responded. All you need to do is add a middleware function at the very bottom of the stack (below all other functions) to handle a 404 response:

app.use(function (req, res, next) {
  res.status(404).send("Sorry can't find that!")
})

// You define error-handling middleware in the same way as other middleware, except with four arguments instead of three; specifically with the signature (err, req, res, next)

app.use(function (err, req, res, next) {
  console.error(err.stack)
  res.status(500).send('Something broke!')
})


// AUTHORIZATION:
app.use(function(req, res, next) {
  if (!req.headers.authorization) {
    return res.status(403).json({ error: 'No credentials sent!' });
  }
  next();
});

// ...all your protected routes...


axios(zendeskAPI)
  .then((response) => {
    res.send(response.data)
  })
  .catch((err) => {
    console.log(err.response.status)
    res.sendStatus(err.response.status)
  })


axios(zendeskAPI)
  .then((response) => {
    res.send(response.data)
  })
  .catch((err) => {
    res.status(err.response.status).send({
      msg: err.message,
      stack: stack
    })
  })


  // ? Express Router
// To set it up ...
const router = express.Router()

router.get('/pokemon')

module.exports = router

server.js 

app.use('/birds', birds)


// ? HEADERS:

$frontend
$index.html
<script axios cdn></script>

$script.js
axios.get('http://localhost:3000/headers', {headers : {key: value}})


$backend
app.use(cors())




app.get('/', req, res => {
  const { username, passoword } = req.headers
  console.log(username, password)
})

// making get request with headers using axios

axios.get('/endpoint')


const myHeaders = {
  headers: {
    username: 'username',
    password: 'password'
  }
}

axios.get('url', myHeaders)
  .then((response) => console.log(response))
  .then((err) => console.log(err))


  // find and kill PORT
  ps aux | grep 3000
  kill -9 <pid>
  
  pgrep mongo -> shows pid number
  
  // find and kill mongodb
  sudo killall -15 mongod



// HOW TO RUN MIDDLEWARE CHECK ON ALL ROUTES EXCEPT FOR ONE:

app.all('*', checkUser);

function checkUser(req, res, next) {
  if ( req.path == '/') return next();

  //authenticate user
  next();
}