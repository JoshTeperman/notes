// begin rescue in Ruby

const myError = new Error('this is an error message')
console.log(myError.message) // => this is an error message

error.stack 
// returns stack trace

// ! You must handle ('catch') your error in some way, else it will STOP YOUR CODE 

TRY & CATCH 

// in try we execute some code
// to create an error we use throw new Error()
// when the error is thrown, we handle that error in catch
// must use a catch at the end of a try block 


try {
  const value = true
  if (value != true) {
    throw new Error("this value isn't true")
  } else {
    console.log('everything is ok')
  }
}
catch(error) {
  console.log(error)
}

// throw is invoked and goes to the catch, error.message takes the value of the throw string


// custom error example 1
function customError(message) {
  this.message = message
}

try {
  const value = true
  if (value != true) {
    throw new customError("this value isn't true")
  } else {
    console.log('everything is ok')
  }
}
catch(error) {
  console.log(e.message)
}

// custom error example 2
const getAreaOfRectangle = (length, width) => {
  if (typeof(length) !== "number" || typeof(width) !== "number") {
    throw("the arguments you passed aren't numbers")
  } else {
    return length * width
  }
}
try {
  const result = getAreaOfRectangle(2,2)
  console.log(result)
}
catch(error) {
  console.log(error)
}

// Example 3: (from MDN)
// constructor function returns an object UserException
// UserException has a message attribute and a name attribute
// Therefore can catch error and use attributes to give information about the error

function UserException(message) {
  this.message = message;
  this.name = 'UserException';
}
function getMonthName(mo) {
  mo = mo - 1; // Adjust month number for array index (1 = Jan, 12 = Dec)
  var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
     'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  if (months[mo] !== undefined) {
     return months[mo];
  } else {
     throw new UserException('InvalidMonthNo'); // throws an exception, creates a new instance of UserException
  }
}

try {
  // statements to try
  var myMonth = 15; // 15 is out of bound to raise the exception
  var monthName = getMonthName(myMonth);
} catch (e) {
  monthName = 'unknown';
  console.log(e.message, e.name); // pass exception object to err handler
}

// Example 4: Custom Errors using switch statement:

throw([1, "Error 1"]);
throw([2, "Error 2"]);

switch(error[0]) {
  catch(error) {
        case 1:
            // logic
            break;

        case 2:
            // logic
            break;

        default:
            // logic
            console.log("any other error");
            break;
    }
}

if (response.status !== 200) {
  throw Error(response.message)
  return error
}


// * The Definitive Guid to Handling Errors Gracefully in Javascript
// https://levelup.gitconnected.com/the-definite-guide-to-handling-errors-gracefully-in-javascript-58424d9c60e6

// ? TRY & CATCH

const a = 5

try {
    console.log(b) // b is not defined, so throws an error
} catch (err) {
    console.error(err) // will log the error with the error stack
}

console.log(a) // still gets executed

// ? FINALLY

// Sometimes it is necessary to execute code in either case, whether there is an Error or not. You can use the third, optional block finally for that. Often, it is the same as just having a line after the try … catch statement, but sometimes it can be useful.

const a = 5

try {
    console.log(b) // b is not defined, so throws an error
} catch (err) {
    console.error(err) // will log the error with the error stack
} finally {
    console.log(a) // will always get executed
}

// ? ERRORS & ASYNCHRONOUS_FUNCTIONS
// ! always add a catch block to your async functions

// * Using .then .catch with Promises:
Promise.resolve(1)
  .then(res => {
    console.log(res) // 1
    throw new Error('error something wrong')
    return Promise.resolve(2)
  })
  .then(res => {
    console.log(res) // will not get executed
  })
  .catch(err => {
    console.error(err)
    return Promise.resolve(3)
  })
  .then(res => {
    console.log(res) // 3
  })
  .catch(err => {
    console.error(err) // will catch any errors in prev block
  })

  // * Using try & catch with async await:

  ;(async function() {
    try {
      await someFuncthatThrowsAnError()
    } catch (err) {
      console.error(err)
    }
    console.log('this will still get executed')
  })


  // * Structuring Error Handling in an App with Express API and front-end client

// ? 1) Generic Error handling
// ... some kind of fallback, that basically just says: ‘Something went wrong, please try again or contact us’. This is not especially smart, but at least notifies the user that something is wrong — instead of infinite loading or similar.
// ? 2) Specific Error handling 
// ... in order to give the user detailed information about what is wrong and how to fix it, e.g. there is some information missing, the entry already exists in the database, etc.

