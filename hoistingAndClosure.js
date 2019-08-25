// HOISTING -->

// the order your compiler sees your code

// var inside function = top of function block
// var outside functin = global scope (top of page)
// anything within a function is local to that function and will not get hoisted (even another function)

// moves var variable up to the top, but as var variable; -> any variable assignment will not be logged until called in the code, therefore return undefined


// let and var can be initialized without a value (will return undefined)
// const and var do not get hoisted
// const and let will return an error ' is not defined'

// CLOSURE -->

// lexical scoping language -- > inheritance flows inwards
// variable outside a funciton is available for use within the function but not outsdide

// mimic the functionality of private functions
// nested functions can access value of their parents, but not their children
// variables within the closure function are only accessible through the parent fucntion, and not from any other part of the code. The only thing that get's exposed to the global scope is the parent function, not the variable inside.

// Closure Example:

function outside() {
  let x = 2;
  return function inside(y) {
    return x * y;
  }
}

const myClosureFunction = outside();
myClosureFunction(5)
// 10

x = 4
myClosureFunction(5)
// 10

// Notice how it's still 10. The x inside the closure is different than the x outside

// Another example
//  let add5 = adder(5) -> same as defining let x = 5 within the function (example above)
function adder(x) {
  return function(y) {
    return x + y
  }
}

let add5 = adder(5);
let add10 = adder(10);

console.log(add5(2)); // 7
console.log(add10(2)); // 12