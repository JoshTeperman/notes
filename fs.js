// https://nodejs.org/api/fs.html
// use with Stringify > https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
// NODE IS ASYNCHRONOUS: 'the function you have defined is an asynchronous callback. It doesn't execute right away, rather it executes when the file loading has completed. When you call readFile, control is returned immediately and the next line of code is executed. So when you call console.log, your callback has not yet been invoked, and this content has not yet been set. Welcome to asynchronous programming.'

// Or better yet, as Raynos example shows, wrap your call in a function and pass in your own callbacks. (Apparently this is better practice) I think getting into the habit of wrapping your async calls in function that takes a callback will save you a lot of trouble and messy code.

function doSomething (callback) {
  // any async callback invokes callback with response
}

doSomething (function doSomethingAfter(err, result) {
  // process the async result
});

// SIMPLE (SYNCHRONOUS) APPENDING AND READING
fs.appendFileSync(file, data);
const getData = fs.readFileSync(file, 'UTF8')
console.log(getData)

// PROPER (ASYNCHRONOUS) OPENING, APPENDING, CLOSING

// open
fs.openFile(file, 'a', (err, file) => {
  if (err) throw err;
// append
  fs.appendFile(file, data, (err) => {
    if (err) throw err;
    console.log('data appended to file');
  })
// close
  fs.close(file, (err) => {
    if (err) throw err;
  })
})

// read and log
fs.readFile(file, "UTF8", (err, data) => {
  if (err) throw err;
  console.log(data);
});



// --> OPEN A FILE with fs.open()

fs.open(path[, flags[, mode]], callback)
// default mode is 'r'

// fd <integer>
// buffer <Buffer> | <TypedArray> | <DataView>
// offset <integer>
// length <integer>
// position <integer>
// callback <Function>
  // err <Error>
  // bytesRead <integer>
  // buffer <Buffer>
// Read data from the file specified by fd.
// buffer is the buffer that the data will be written to.
// offset is the offset in the buffer to start writing at.
// length is an integer specifying the number of bytes to read.
// position is an argument specifying where to begin reading from in the file. If position is null, data will be read from the current file position, and the file position will be updated. If position is an integer, the file position will remain unchanged.
// The callback is given the three arguments, (err, bytesRead, buffer).
// If this method is invoked as its util.promisify()ed version, it returns a Promise for an Object with bytesRead and buffer properties.

fs.open('myfile', 'wx', (err, fd) => {
  if (err) {
    if (err.code === 'EEXIST') {
      console.error('myfile already exists');
      return;
    }
    throw err;
  }
  writeMyData(fd);
});


// --> READ A FILE with fs.readFile()

fs.readFile(path[, options], callback)
  // Asynchronously reads the entire contents of a file.

// path <string> | <Buffer> | <URL> | <integer> filename or file descriptor
// options <Object> | <string>
  // encoding <string> | <null> Default: null
  // flag <string> See support of file system flags. Default: 'r'.
// callback <Function>
  // err <Error>
  // data <string> | <Buffer>

// The callback is passed two arguments (err, data), where data is the contents of the file.
// If no encoding is specified, then the raw buffer is returned.

// If no encoding is passed (eg utf-8 or UTF8), the default buffer data will be parsed
// Else you can call data.toString() 

fs.readFile('/etc/passwd', encoding, (err, data) => {
  if (err) throw err;
  console.log(data);
});


fs.open('myfile', 'r', (err, fd) => {
  if (err) {
    if (err.code === 'ENOENT') {
      console.error('myfile does not exist');
      return;
    }
    throw err;
  }
  readMyData(fd);
});

// As readFile is asynchronous, console.log(global_data); occurs before the reading, and before the global_data = data; line is executed.

// The right way is this :

fs.readFile("example.txt", "UTF8", (err, data) => {
    if (err) { throw err };
    global_data = data;
    console.log(global_data);
});
// In a simple program (usually not a web server), you might also want to use the synchronous operation readFileSync but it's generally preferable not to stop the execution.

// Using readFileSync, you would do

var global_data = fs.readFileSync("example.txt").toString();

// --> WRITE TO A FILE with fs.write()

fs.write(fd, buffer[, offset[, length[, position]]], callback)

// fd <integer>
// buffer <Buffer> | <TypedArray> | <DataView>
// offset <integer>
// length <integer>
// position <integer>
// callback <Function>
//   err <Error>
//   bytesWritten <integer>
//   buffer <Buffer> | <TypedArray> | <DataView>

// Write buffer to the file specified by fd.

// offset determines the part of the buffer to be written, and length is an integer specifying the number of bytes to write.

// position refers to the offset from the beginning of the file where this data should be written. If typeof position !== 'number', the data will be written at the current position.


fs.write(fd, string[, position[, encoding]], callback)

// fd <integer>
// string <string>
// position <integer>
// encoding <string> Default: 'utf8'
// callback <Function>
//   err <Error>
//   written <integer>
//   string <string>


// Write string to the file specified by fd. If string is not a string, then the value will be coerced to one.

// position refers to the offset from the beginning of the file where this data should be written. If typeof position !== 'number' the data will be written at the current position.

// It is unsafe to use fs.write() multiple times on the same file without waiting for the callback. For this scenario, fs.createWriteStream() is recommended.





// --> WRITE TO A FILE wth fs.writeFile()

fs.writeFile(file, data[, options], callback)

// When file is a filename, asynchronously writes data to the file, replacing the file if it already exists. data can be a string or a buffer.

// When file is a file descriptor, the behavior is similar to calling fs.write() directly (which is recommended). See the notes below on using a file descriptor.

fs.writeFile('log.txt', 'Hello Node', function (err) {
  if (err) throw err;
  console.log('It\'s saved!');
}); // => message.txt erased, contains only 'Hello Node'



// --> ASYNCHRONOUSLY APPEND TO A FILE with fs.append()

fs.appendFile(path, data[, options], callback)
// Asynchronously append data to a file, creating the file if it does not yet exist. data can be a string or a Buffer.

// path <string> | <Buffer> | <URL> | <number> filename or file descriptor
// data <string> | <Buffer>
// options <Object> | <string>
  // encoding <string> | <null> Default: 'utf8'
  // mode <integer> Default: 0o666
  // flag <string> See support of file system flags. Default: 'a'.
// callback <Function>
  // err <Error></Error>

fs.appendFile('message.txt', 'data to append', (err) => {
  if (err) throw err;
  console.log('The "data to append" was appended to file!');
});

// The path may be specified as a numeric file descriptor that has been opened for appending (using fs.open() or fs.openSync()). The file descriptor will not be closed automatically.

const file = 'file.txt'
data = JSON.stringify('some data')

// SIMPLY
fs.appendFileSync(file, data);

// OR
fs.open(file, 'a', (err, file) => {
  if (err) throw err;
  // append to file
  fs.appendFile(file, data, (err) => {
    if (err) throw err;
    console.log('The "data to append" was appended to file!');
  });
  // always close the file descriptor!
  fs.close(file, (err) => {
    if (err) throw err;
  });
});


Asynchronously:


fs.appendFile('message.txt', 'data to append', function (err) {
  if (err) throw err;
  console.log('Saved!');
});

Synchronously:

fs.appendFileSync('message.txt', 'data to append');

// See notes on how to append to a file repeatedly (avoid EMFILE errors)
// https://stackoverflow.com/questions/3459476/how-to-append-to-a-file-in-node/43370201#43370201


// --> SYNCHRONOUSLY APPEND DATA TO A FILE with fs.appendFileSync()

fs.appendFileSync(path, data[, options])
// Synchronously append data to a file, creating the file if it does not yet exist. data can be a string or a Buffer.

// path <string> | <Buffer> | <URL> | <number> filename or file descriptor
// data <string> | <Buffer>
// options <Object> | <string>
  // encoding <string> | <null> Default: 'utf8'
  // mode <integer> Default: 0o666
  // flag <string> See support of file system flags. Default: 'a'.

try {
  fs.appendFileSync('message.txt', 'data to append');
  console.log('The "data to append" was appended to file!');
} catch (err) {
  /* Handle the error */
}
  
// The path may be specified as a numeric file descriptor that has been opened for appending (using fs.open() or fs.openSync()). The file descriptor will not be closed automatically.

let fd;

try {
  fd = fs.openSync('message.txt', 'a');
  fs.appendFileSync(fd, 'data to append', 'utf8');
} catch (err) {
  /* Handle the error */
} finally {
  if (fd !== undefined)
    fs.closeSync(fd);
}


// --> CHECK FILE ACCESS WITH  fs.access()

fs.access(path[, mode], callback)
// Tests a user's permissions for the file or directory specified by path. The mode argument is an optional integer that specifies the accessibility checks to be performed. 
// The final argument, callback, is a callback function that is invoked with a possible error argument. If any of the accessibility checks fail, the error argument will be an Error object. The following examples check if package.json exists, and if it is readable or writable.
// Check if the file exists in the current directory, and if it is writable.
fs.access(file, fs.constants.F_OK | fs.constants.W_OK, (err) => {
  if (err) {
    console.error(
      `${file} ${err.code === 'ENOENT' ? 'does not exist' : 'is read-only'}`);
  } else {
    console.log(`${file} exists, and it is writable`);
  }
});

// --> CHECK FILE PATH EXISTS with fs.exists()

fs.exists(path, callback)
// Test whether or not the given path exists by checking with the file system. Then call the callback argument with either true or false:

fs.exists('/etc/passwd', (exists) => {
  console.log(exists ? 'it\'s there' : 'no passwd!');
});

// The parameters for this callback are not consistent with other Node.js callbacks. Normally, the first parameter to a Node.js callback is an err parameter, optionally followed by other parameters. The fs.exists() callback has only one boolean parameter. This is one reason fs.access() is recommended instead of fs.exists().

// Using fs.exists() to check for the existence of a file before calling fs.open(), fs.readFile() or fs.writeFile() is not recommended. Doing so introduces a race condition, since other processes may change the file's state between the two calls. Instead, user code should open/read/write the file directly and handle the error raised if the file does not exist.

// --> ASYNCHRONOUSLY CREATE A DIRECTORY with fs.mkdir()

fs.mkdir(path[, options], callback)

// Creates /tmp/a/apple, regardless of whether `/tmp` and /tmp/a exist.
fs.mkdir('/tmp/a/apple', { recursive: true }, (err) => {
  if (err) throw err;
});


// --> CREATE A DIRECTORY SYNCHRONOUSLY with fs.mkdirSync()

fs.mkdirSync(path[, options])[src]#


// --> RENAME A FILE with fs.rename()

fs.rename(oldPath, newPath, callback)[src]#

// oldPath <string> | <Buffer> | <URL>
// newPath <string> | <Buffer> | <URL>
// callback <Function>
  // err <Error>

  // Asynchronously rename file at oldPath to the pathname provided as newPath. In the case that newPath already exists, it will be overwritten. No arguments other than a possible exception are given to the completion callback.


fs.rename('oldFile.txt', 'newFile.txt', (err) => {
  if (err) throw err;
  console.log('Rename complete!');
});

// --> REMOVE A FILE with fs.unlink()

fs.unlink(path, callback)[src]#

// path <string> | <Buffer> | <URL>
// callback <Function>
  // err <Error>

  // Asynchronously removes a file or symbolic link. No arguments other than a possible exception are given to the completion callback.

// Assuming that 'path/file.txt' is a regular file.

fs.unlink('path/file.txt', (err) => {
  if (err) throw err;
  console.log('path/file.txt was deleted');
});

// fs.unlink() will not work on a directory, empty or otherwise. To remove a directory, use fs.rmdir().



// USING PROMISES

// Using Promises with ES7
// Asynchronous use with mz/fs
// The mz module provides promisified versions of the core node library. Using them is simple. First install the library...

npm install mz
// Then...

const fs = require('mz/fs');
fs.readFile('./Index.html').then(contents => console.log(contents))
  .catch(err => console.error(err));

// Alternatively you can write them in asynchronous functions:

async function myReadfile () {
  try {
    const file = await fs.readFile('./Index.html');
  }
  catch (err) { console.error( err ) }
};


// USING JSON DATA

// You can require the .json fiile which returns a JSON object:
// note that require is synchronous and only reads the file once, following calls return the result from cache

const someModule = require('./some-module.json');
console.log(someModule);
// => 
[
  { func1: function1},
  { func2: function2}
]

// You can use JSON.parse() on any String containing JSON data
const str = '{ "name": "John Doe", "age": 42 }';
const obj = JSON.parse(str);

// Asynchronous version:
fs.readFile('/path/to/file.json', 'utf8', function (err, data) {
  if (err) throw err; // we'll not consider error handling for now
  const obj = JSON.parse(data);
});

// Synchronous version:
const json = JSON.parse(fs.readFileSync('/path/to/file.json', 'utf8'));

// PARSING JSON from streams:

// If the JSON content is streamed over the network, you need to use a streaming JSON parser. Otherwise it will tie up your processor and choke your event loop until JSON content is fully streamed.

// There are plenty of packages available in NPM for this: 
// https://www.npmjs.com/search?q=json%20parse%20stream

// Error Handling/Security

// If you are unsure if whatever that is passed to JSON.parse() is valid JSON, make sure to enclose the call to JSON.parse() inside a try/catch block. A user provided JSON string could crash your application, and could even lead to security holes. Make sure error handling is done if you parse externally-provided JSON.

